//
//  VideoDetailViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import UIKit
import Combine
import AVKit
import AVFoundation

final class DetailViewController: ViewController {

    enum Wrapper: Hashable {
      case videoInfo(Video)
      case channelInfo(Channel)
      case relatedVideos(Video)
    }

    enum Section: Int, CaseIterable {
        case videoInfo
        case channelInfo
        case relatedVideos
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Wrapper>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Wrapper>

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var videoContainerView: UIView!

    // MARK: - Properties
    var viewModel: DetailViewModel?
    private var player: AVPlayer?
    private var dataSource: DataSource!

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .white
        setupTableView()
        setupAVPlayer()
    }

    override func setupData() {
        super.setupData()
        loadData()
    }

    override func binding() {
        super.binding()
        guard let viewModel = viewModel else { return }
        viewModel.$videosApiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        viewModel.$channelApiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        // Handle reload tableview after all apis finish
        Publishers.Zip(viewModel.channel, viewModel.relatedVideos)
            .sink { [weak self] channel, relatedVideos in
                guard let this = self else { return }
                var wrappers: [Wrapper] = [.videoInfo(viewModel.video), .channelInfo(channel)]
                for video in relatedVideos {
                    wrappers.append(.relatedVideos(video))
                }
                this.applySnapshot(wrappers)
            }
            .store(in: &subscriptions)
    }

    // Binding to load more
    private func bindingRelatedVideos() {
        guard let viewModel = viewModel else { return }
        viewModel.relatedVideos
            .sink { [weak self] relatedVideos in
                guard let this = self else { return }
                var wrappers: [Wrapper] = [.videoInfo(viewModel.video), .channelInfo(viewModel.channel.value)]
                for video in relatedVideos {
                    wrappers.append(.relatedVideos(video))
                }
                this.applySnapshot(wrappers)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Private
    private func setupTableView() {
        tableView.register(VideoTableViewCell.self)
        tableView.register(ChannelInfoTableViewCell.self)
        tableView.register(VideoInfoTableViewCell.self)
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        makeDataSource()
    }

    private func makeDataSource() {
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, wrapper) -> UITableViewCell? in
                guard let this = self, let viewModel = this.viewModel else { return UITableViewCell() }
                switch wrapper {
                case .videoInfo:
                    let cell = tableView.dequeue(VideoInfoTableViewCell.self)
                    cell.viewModel = viewModel.viewModelForVideoInfo(at: indexPath)
                    return cell
                case .channelInfo:
                    let cell = tableView.dequeue(ChannelInfoTableViewCell.self)
                    cell.viewModel = viewModel.viewModelForChannelInfo(at: indexPath)
                    return cell
                case .relatedVideos:
                    let cell = tableView.dequeue(VideoTableViewCell.self)
                    cell.viewModel = viewModel.viewModelForRelatedVideo(at: indexPath)
                    return cell
                }
            })
    }

    private func applySnapshot(_ wrappers: [Wrapper]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.videoInfo, .channelInfo, .relatedVideos])
        snapshot.appendItems([wrappers[0]], toSection: .videoInfo)
        snapshot.appendItems([wrappers[1]], toSection: .channelInfo)
        snapshot.appendItems(Array(wrappers[2..<wrappers.count]), toSection: .relatedVideos)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func loadData() {
        guard let viewModel = viewModel else { return }
        viewModel.getChannelInfo()
        viewModel.getRelatedVideos()
    }

    private func setupAVPlayer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapVideo))
        tapGesture.cancelsTouchesInView = false
        videoContainerView.addGestureRecognizer(tapGesture)

        if let url = viewModel?.getUrlForPlaying() {
            player = AVPlayer(url: url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            playerController.view.frame = CGRect(origin: .zero, size: videoContainerView.bounds.size)
            videoContainerView.addSubview(playerController.view)
            addChild(playerController)
        }
    }

    // MARK: - Objc
    @objc private func handleTapVideo(_ sender: UIGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        DispatchQueue.main.async {
            if !viewModel.isVideoPlaying {
                self.player?.play()
            } else {
                self.player?.pause()
            }
            viewModel.isVideoPlaying = !viewModel.isVideoPlaying
        }
    }

}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 50
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
              viewModel.isNeedLoadMore(at: indexPath) else { return }
        bindingRelatedVideos()
        viewModel.getRelatedVideos()
    }
}

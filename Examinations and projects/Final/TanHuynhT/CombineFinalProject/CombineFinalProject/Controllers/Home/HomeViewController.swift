//
//  HomeViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/17/21.
//

import UIKit
import SwiftUtils

final class HomeViewController: ViewController {

    enum Section: Int, CaseIterable {
        case list
    }

    typealias VideosDataSource = UITableViewDiffableDataSource<Section, Video>
    typealias VideosSnapshot = NSDiffableDataSourceSnapshot<Section, Video>

    typealias ChannelsDataSource = UITableViewDiffableDataSource<Section, VideoChannel>
    typealias ChannelsSnapshot = NSDiffableDataSourceSnapshot<Section, VideoChannel>

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var searchView: UIView!

    private var videosDataSource: VideosDataSource!
    private var channelsDataSource: ChannelsDataSource!
    var searchResultTableView = UITableView()
    var viewModel: HomeViewModel = HomeViewModel()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        title = "Youtube"
        view.backgroundColor = .white

        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.cornerRadius = 10
        searchView.addInnerShadow()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        setupVideosTableView()
        setupChannelsTableView()
        setupTextField()
    }

    override func setupData() {
        super.setupData()
        getRecommendVideos()
    }

    override func binding() {
        super.binding()
        bindingVideos()
        bindingChannels()
    }

    private func bindingVideos() {
        viewModel.$videosApiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        viewModel.videos
            .sink { [weak self] videos in
                guard let this = self else { return }
                this.applyVideosSnapshot(videos)
            }
            .store(in: &subscriptions)
    }

    private func bindingChannels() {
        viewModel.$channelsApiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        viewModel.chanels
            .sink { [weak self] channels in
                guard let this = self else { return }
                this.applyChannelsSnapshot(channels)
            }
            .store(in: &subscriptions)
    }

    private func setupVideosTableView() {
        // For recommend videos
        tableView.register(VideoTableViewCell.self)
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        videosDataSource = VideosDataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, data) -> UITableViewCell? in
                guard let this = self else { return UITableViewCell() }
                let cell = tableView.dequeue(cell: VideoTableViewCell.self, forIndexPath: indexPath)
                cell.viewModel = this.viewModel.viewModelForCell(at: indexPath)
                return cell
            })
    }

    private func setupChannelsTableView() {
        // For searching
        searchResultTableView.register(KeySearchResultTableViewCell.self)
        searchResultTableView.delegate = self
        searchResultTableView.tableFooterView = UIView()

        channelsDataSource = ChannelsDataSource(
            tableView: searchResultTableView,
            cellProvider: { [weak self] (tableView, indexPath, data) -> UITableViewCell? in
                guard let this = self else { return UITableViewCell() }
                let cell = tableView.dequeue(cell: KeySearchResultTableViewCell.self, forIndexPath: indexPath)
                cell.viewModel = this.viewModel.viewModelForCellSearchResult(at: indexPath)
                return cell
            })
    }

    private func setupTextField() {
        searchTextField.delegate = self

        // Create publisher for textfield
        let textFieldPublisher = searchTextField.textPublisher()
        textFieldPublisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { value in
                self.checkToShowSearchResult(keyword: value)
                self.searchChannels(keyword: value)
            }.store(in: &subscriptions)
    }

    // Snapshot
    private func applyVideosSnapshot(_ data: [Video]) {
        var snapshot = VideosSnapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(data, toSection: .list)
        videosDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func applyChannelsSnapshot(_ data: [VideoChannel]) {
        var snapshot = ChannelsSnapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(data, toSection: .list)
        channelsDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    //MARK: - ObjecC
    @objc func handleDismiss(sender: UIGestureRecognizer?) {
        searchTextField.text = ""
        searchTextField.endEditing(true)
        viewModel.clearSearchResults()
        searchResultTableView.removeFromSuperview()
        searchResultTableView.reloadData()
        backgroundView.alpha = 0
    }

    private func getRecommendVideos() {
        viewModel.getRecommendVideos()
    }

    private func searchChannels(keyword: String) {
        print("Value issssssss \(keyword) at \(Date())")
        guard !keyword.isEmpty else { return }
        viewModel.searchChannels(keyword: keyword)
    }

    private func checkToShowSearchResult(keyword: String) {
        if !keyword.isEmpty && !view.subviews.contains(searchResultTableView) {
            showSearchResultTableView()
        } else if keyword.isEmpty {
            viewModel.clearSearchResults()
            searchResultTableView.removeFromSuperview()
            searchResultTableView.reloadData()
            backgroundView.alpha = 0
        }
    }

    private func showSearchResultTableView() {
        searchResultTableView.frame = CGRect(x: self.view.bounds.origin.x, y: -self.view.bounds.size.height, width: self.view.bounds.size.width, height: 350)
        view.addSubview(searchResultTableView)
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.searchResultTableView.frame.origin.y = self.tableView.frame.origin.y
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(withDuration: 0.0, delay: 0, options: .curveEaseOut, animations: {
                    self.backgroundView.alpha = 0.3
                }, completion: nil)
            })
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.tableView:
            return UITableView.automaticDimension
        case searchResultTableView:
            return 20
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.viewModel = viewModel.viewModelForDetail(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.isNeedLoadMore(at: indexPath) else { return }
        getRecommendVideos()
    }
}

// MARK: UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text else { return true }
        handleDismiss(sender: nil)
        let vc = SearchResultViewController()
        vc.viewModel = SearchResultViewModel(keyword: keyword)
        navigationController?.pushViewController(vc, animated: true)
        return true
    }
}

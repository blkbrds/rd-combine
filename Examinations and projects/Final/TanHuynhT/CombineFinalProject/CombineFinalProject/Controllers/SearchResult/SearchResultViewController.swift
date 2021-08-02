//
//  SearchResultViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import UIKit

final class SearchResultViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: SearchResultViewModel?
    var isFirstAppear: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

        guard isFirstAppear, let viewModel = viewModel else { return }
        isFirstAppear = false
        title = "Results of \"\(viewModel.keyword)\""
        searchVideos(keyword: viewModel.keyword)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupUI() {
        view.backgroundColor = .white
    }

    private func setupTableView() {
        tableView.register(VideoTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func searchVideos(keyword: String) {
        guard let viewModel = viewModel else { return }
        hud.show()
        viewModel
            .searchVideos(keyword: keyword)
            .sink { completion in
                hud.dismiss()
                switch completion {
                case .failure: break
                case .finished:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } receiveValue: { _ in
            }.store(in: &viewModel.subscriptions)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(VideoTableViewCell.self)
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, viewModel.isNeedLoadMore(at: indexPath) else { return }
        searchVideos(keyword: viewModel.keyword)
    }
}

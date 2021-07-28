//
//  NewsViewController.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class NewsViewController: ViewController {

    // MARK: - Defination
    enum Section: Int, CaseIterable {
        case articles
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Article>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: TableView!

    // MARK: - Properties
    private var dataSource: DataSource!

    var viewModel: NewsViewModel = NewsViewModel()
    override var viewModelType: ViewModelType? {
        get {
            return viewModel
        }
        set {
            super.viewModelType = newValue
        }
    }

    // MARK: - Override functions
    override func setupUI() {
        super.setupUI()
        configTableView()
    }

    override func setupData() {
        super.setupData()
        viewModel.performGetListType()
    }

    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onSucess: { [weak self] in
                self?.navigationItem.title = "\($0.totalResults) news"
                self?.applySnapshot($0.articles)
            }, onFailure: { [weak self] in
                self?.alert(error: $0)
            })
            .store(in: &subscriptions)
    }

    // MARK: - Private functions
    private func configTableView() {
        tableView.register(NewsCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()

        // make data source for collection view
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, data) -> TableCell? in
                guard let this = self else { return nil }
                let cell = tableView.dequeue(cell: NewsCell.self,
                                             forIndexPath: indexPath)
                cell.viewModel = NewsCellViewModel(title: data.title,
                                                   subTitle: data.author,
                                                   itemBackgroundColor: this.viewModel.itemBackgroundColor(at: indexPath))
                return cell
            })
    }

    private func applySnapshot(_ data: [Article]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.articles])
        snapshot.appendItems(data, toSection: .articles)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
//extension NewsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let article = dataSource.itemIdentifier(for: indexPath) else { return }
//        let vc = ListWorkViewController()
//        vc.viewModel = ListWorkViewModel(article: article)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}

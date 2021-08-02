//
//  ListWorkViewController.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class ListWorkViewController: ViewController {

    // MARK: - Declaration
    enum Section: Int, CaseIterable {
        case list
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Work>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Work>

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: TableView!

    // MARK: - Properties
    private var dataSource: DataSource!

    var viewModel: ListWorkViewModel!
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
        navigationItem.title = viewModel.title
        configTableView()
    }

    override func setupData() {
        super.setupData()
        viewModel.performGetListWork()
    }

    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onFailure: { [weak self] in
                self?.alert(error: $0)
            })
            .store(in: &subscriptions)
        viewModel.works
            .sink { [weak self] in
                guard let this = self else { return }
                this.applySnapshot($0, moveToTop: this.viewModel.works.value.count <= this.viewModel.limit)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Private functions
    private func configTableView() {
        tableView.register(WorkCell.self)
        tableView.tableFooterView = UIView()

        // make data source for collection view
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, data) -> TableCell? in
                let cell = tableView.dequeue(cell: WorkCell.self, forIndexPath: indexPath)
                cell.viewModel = WorkCellViewModel(work: data)
                return cell
            })
    }

    private func applySnapshot(_ data: [Work], moveToTop: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(data, toSection: .list)
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let this = self else { return }
            if moveToTop {
                this.tableView.setContentOffset(CGPoint(x: this.tableView.contentOffset.x, y: 0), animated: false)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ListWorkViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - contentOffset <= 10 {
            viewModel.performLoadMoreListWork()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let contentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - contentOffset <= 10 {
                viewModel.performLoadMoreListWork()
            }
        }
    }
}

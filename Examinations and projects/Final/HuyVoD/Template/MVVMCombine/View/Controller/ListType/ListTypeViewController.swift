//
//  ListTypeViewController.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class ListTypeViewController: ViewController {

    // MARK: - Defination
    enum Section: Int, CaseIterable {
        case list
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Type>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Type>

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: TableView!

    // MARK: - Properties
    private var dataSource: DataSource!

    var viewModel: ListTypeViewModel = ListTypeViewModel()
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
                self?.navigationItem.title = "\($0.totalResults) results"
                self?.applySnapshot($0.types)
            }, onFailure: { [weak self] in
                self?.alert(error: $0)
            })
            .store(in: &subscriptions)
    }

    // MARK: - Private functions
    private func configTableView() {
        tableView.register(TypeCell.self)
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()

        // make data source for collection view
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, data) -> TableCell? in
                let cell = tableView.dequeue(cell: TypeCell.self, forIndexPath: indexPath)
                cell.viewModel = TypeCellViewModel(title: data.label)
                return cell
            })
    }

    private func applySnapshot(_ data: [Type]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.list])
        snapshot.appendItems(data, toSection: .list)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension ListTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = ListWorkViewController()
        vc.viewModel = ListWorkViewModel(type: type)
        navigationController?.pushViewController(vc, animated: true)
    }
}

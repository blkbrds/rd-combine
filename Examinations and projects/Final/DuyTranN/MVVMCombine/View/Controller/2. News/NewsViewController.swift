//
//  NewsViewController.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import Combine

final class NewsViewController: ViewController {

    // MARK: - Defination
    enum Section: Int, CaseIterable {
        case articles
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Article>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: TableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var noDataLabel: UILabel!

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
        /// `Search text field`
        searchTextField.addTarget(self,
                                  action: #selector(textFieldEditingChanged(textField:)),
                                  for: .editingChanged)

        /// `Tap gesture`
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped(_:)))
        view.addGestureRecognizer(tapGesture)

        /// `Table view`
        configTableView()
    }

    override func setupData() {
        super.setupData()
        viewModel.requestGetListArticles()
    }

    override func binding() {
        super.binding()
        /// Search input
        viewModel.searchInputSubject
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
                guard let this = self, value.isNotEmpty else { return }
                print("☘️ Begin search with \"\(value)\"")
                this.viewModel.requestSearchArticles()
            })
            .store(in: &subscriptions)

        /// API on first load
        viewModel.$apiResult
            .handle(onSucess: { [weak self] in
                self?.navigationItem.title = "\($0.totalResults) news"
                self?.applySnapshot($0.articles)
                self?.noDataLabel.isHidden = $0.articles.isNotEmpty
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

    @objc private func textFieldEditingChanged(textField: UITextField) {
        viewModel.searchInputSubject.send(textField.value)
    }

    @objc private func superViewTapped(_ gesture: UIGestureRecognizer) {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
    }
}

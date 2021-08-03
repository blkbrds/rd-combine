//
//  HomeViewController.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/21/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {

    enum Section: Int, CaseIterable {
        case home
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, Drink>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Drink>
    typealias DataSourceCollectionView = UICollectionViewDiffableDataSource<Section, Category>
    typealias SnapshotCollectionView = NSDiffableDataSourceSnapshot<Section, Category>

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tagCollectionView: UICollectionView!

    private var dataSource: DataSource!
    private var dataSourceCollectionView: DataSourceCollectionView!
    var viewModel: HomeViewModel = HomeViewModel()
    private var oldTagIndex: Int?
    private var newTagIndex: Int = 0 {
        willSet {
            oldTagIndex = newTagIndex
        }

        didSet {
            if let index = oldTagIndex, index != newTagIndex {
                tagCollectionView.reloadData()
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        configTableView()
        configCollectionView()
    }

    override func setupData() {
        super.setupData()
        viewModel.getDrinkByCategory(key: "c=", strCategory: "Ordinary%20Drink")
        viewModel.getCategoryList(key: "c=")
    }

    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onSucess: { [weak self] in
                self?.navigationItem.title = "Category"
                self?.applySnapshot($0)
                self?.viewModel.drinkSuject.value = $0
            }, onFailure: { [weak self] _ in
                self?.showAlert(error: "Call API Failure")
            })
            .store(in: &subscriptions)

        viewModel.$tagGroups
            .handle(onSucess: { [weak self] value in
                self?.applySnapshotForCollectionView(value)
                self?.viewModel.categoryListSubject.value = value
            }, onFailure: { [weak self] _ in
                self?.showAlert(error: "Call API Failure")
            })
            .store(in: &subscriptions)
    }

    private func configTableView() {
        tableView.register(DrinkTableViewCell.self)
        tableView.rowHeight = UIScreen.main.bounds.height / 3

        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, data) -> DrinkTableViewCell? in
            let cell = tableView.dequeue(cell: DrinkTableViewCell.self, forIndexPath: indexPath)
            cell.viewModel = DrinkCellViewModel(idDrink: data.idDrink, drinkName: data.drinkName, imageURL: data.imageURL)
            return cell
        })
    }

    private func configCollectionView() {
        tagCollectionView.register(TagCollectionViewCell.self)

        dataSourceCollectionView = DataSourceCollectionView(collectionView: tagCollectionView, cellProvider: { (tagCollectionView, indexPath, data) -> TagCollectionViewCell? in
            let cell = tagCollectionView.dequeue(cell: TagCollectionViewCell.self, forIndexPath: indexPath)
            if self.newTagIndex == indexPath.row {
                cell.isSelected = true
                cell.isSelectedCell = true
            } else {
                cell.isSelected = false
                cell.isSelectedCell = false
            }
            cell.viewModel = TagCellViewModel(strCategory: data.strCategory)
            return cell
        })
    }

    private func applySnapshot(_ data: [Drink]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.home])
        snapshot.appendItems(data, toSection: .home)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func applySnapshotForCollectionView(_ data: [Category]) {
        var snapshot = SnapshotCollectionView()
        snapshot.appendSections([.home])
        snapshot.appendItems(data, toSection: .home)
        dataSourceCollectionView.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.viewModel = viewModel.viewModelDidSelectRowAt(index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = tagCollectionView.cellForItem(at: indexPath) as? TagCollectionViewCell else {
            return
        }
        cell.isSelectedCell = true
        newTagIndex = indexPath.row

        var keywork: String = ""

        viewModel.categoryListSubject.sink { (value) in
            keywork = value[indexPath.row].strCategory
        }
        .store(in: &subscriptions)

        let newKeyword = keywork.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
        if let newKeyword = newKeyword {
            viewModel.getDrinkByCategory(key: "c=", strCategory: newKeyword)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: UIScreen.main.bounds.height / 20)
    }
}

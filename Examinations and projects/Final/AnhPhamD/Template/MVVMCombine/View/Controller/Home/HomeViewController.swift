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

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var listCollectionView: UICollectionView!
    @IBOutlet private weak var tagCollectionView: UICollectionView!

    private var dataSource: DataSource!
    var viewModel: HomeViewModel = HomeViewModel()

//    override func setupData() {
//        guard let viewModel = viewModel else { return }
//        viewModel.getDrinkByCategory(key: "c", strCategory: "Cocktail")
//        print("Home ViewController")
//    }

    override func setupUI() {
        super.setupUI()
        configTableView()
        print("Setup UI")
    }

    override func setupData() {
        super.setupData()
        print("Setup Data")
        viewModel.getDrinkByCategory(key: "c=", strCategory: "Cocktail")
    }

    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onSucess: { [weak self] in
                print("call API Success")
                self?.navigationItem.title = "Category"
                self?.applySnapshot($0)
            }, onFailure: { [weak self] _ in
                print("call API Failer")
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

    private func applySnapshot(_ data: [Drink]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.home])
        snapshot.appendItems(data, toSection: .home)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

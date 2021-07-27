//
//  HomeViewController.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import UIKit
import Combine

final class HomeViewController: ViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchSubject = PassthroughSubject<String, Error>()

    typealias DataSource = UITableViewDiffableDataSource<String, Cocktail>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Cocktail>
    private var dataSource: DataSource!

    var viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        configSearch()
        configTableView()
        getAPI()
    }

    override func bindingToView() {
        super.bindingToView()
        searchSubject
            .sink { completion in
                print(completion)
            } receiveValue: { searchText in
                self.getAPI(searchText: searchText)
            }
            .store(in: &subscriptions)
    }

    override func bindingToViewModel() {
        super.bindingToViewModel()
    }

    private func getAPI(searchText: String = "") {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        viewModel.getCocktailAPI(searchText: searchText)
            .sink { completion in
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
                switch completion {
                case .failure(let error):
                    print("ERROR:", error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { _ in
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            .store(in: &subscriptions)
    }

    private func configSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cocktail"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        searchController.searchBar.delegate = self
    }

    private func configTableView() {
        tableView.register(HomeTableCell.self)
        tableView.delegate = self
//        tableView.dataSource = self

        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            let cell = tableView.dequeue(HomeTableCell.self)
            cell.viewModel = HomeTableCellVM(name: "", address: "", imageURL: value.imageURL)
            return cell
        })

        viewModel.$filteredUser
            .receive(on: DispatchQueue.main)
            .sink { value in
                var snapShot = Snapshot()
                snapShot.appendSections(["section1"])
                snapShot.appendItems(value, toSection: "section1")
                self.dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
            }
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeTableCell.self)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchSubject.send(searchBar.text ?? "")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchSubject.send(searchBar.text ?? "")
    }
}

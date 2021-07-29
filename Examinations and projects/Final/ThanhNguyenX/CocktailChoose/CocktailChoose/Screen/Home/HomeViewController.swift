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


    typealias DataSource = UITableViewDiffableDataSource<HomeViewModel.Section, Cocktail>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.Section, Cocktail>
    private var dataSource: DataSource!
    private var cellHeights = [IndexPath: CGFloat]()

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
            } receiveValue: { [weak self] searchText in
                guard let self = self else { return }
                self.getAPI(isLoadMore: false, searchText: searchText)
            }
            .store(in: &subscriptions)
    }

    override func bindingToViewModel() {
        super.bindingToViewModel()
    }

    private func getAPI(isLoadMore: Bool = false, searchText: String = "") {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        viewModel.getCocktailAPI(isLoadMore: isLoadMore, searchText: searchText)
            .sink { completion in
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        _ = self.alert(title: "API Error", message: error.errorDescription ?? "")
                    }
                case .finished: break
                }
            } receiveValue: { _ in
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
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
    }

    private func configTableView() {
        tableView.register(HomeTableCell.self)
        tableView.delegate = self

        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            let cell = tableView.dequeue(HomeTableCell.self)
            cell.viewModel = HomeTableCellVM(title: value.nameTitle, description: value.instructions, imageURL: value.imageURL)
            return cell
        })

        viewModel.$filteredUser
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.updateData(on: value)
            }
            .store(in: &subscriptions)
    }

    private func updateData(on cocktail: [Cocktail]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.first])
        snapshot.appendItems(cocktail)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: DetailViewController = DetailViewController()
        vc.viewModel = DetailViewModel(cocktail: viewModel.filteredUser[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last,
            lastVisibleIndexPath.row == viewModel.numberOfItems(inSection: indexPath.section) - 1 {
            if indexPath.row == lastVisibleIndexPath.row,
               let text = searchController.searchBar.text, text.isEmpty {
                getAPI(isLoadMore: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight = cellHeights[indexPath] {
            return cellHeight
        }
        return UITableView.automaticDimension
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        print("UISearchResultsUpdating", text)
        searchSubject.send(text)
    }
}

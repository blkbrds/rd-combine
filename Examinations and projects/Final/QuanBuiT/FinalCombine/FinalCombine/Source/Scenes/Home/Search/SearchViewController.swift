//
//  SearchViewController.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Combine
import Domain

class SearchViewController: UIViewController {
    // MARK: - Enums and Type aliases
    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ToDo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ToDo>

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private weak var refreshControl: UIRefreshControl!
    private weak var noResultsLabel: UILabel!
    private var dataSource: DataSource!
    private var snapshot: Snapshot = .init()
    
    var viewModel: SearchViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var itemSelectedPublisher: PassthroughSubject<String, Never> = .init()

    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tableView.delegate = self
        setupRefreshControl()
        setupNoResults()
        setupDataSource()
        
        let viewModelInput = SearchViewModel.Input(
            refresh: Publishers.ControlEvent(control: refreshControl, events: .valueChanged)
                .map { _ in () }
                .prepend(())
                .eraseToAnyPublisher(),
            itemSelected: itemSelectedPublisher
                .eraseToAnyPublisher(),
            loadMore: tableView.reachedBottomPublisher()
                .debounce(for: 0.1, scheduler: RunLoop.main)
                .eraseToAnyPublisher(),
            search: searchTextField.textPublisher
        )
        
        let viewModelOutput = viewModel?.transform(viewModelInput)
        
        viewModelOutput?.results.receive(on: DispatchQueue.main)
            .catch { [weak self] error -> Just<[ToDo]> in
                self?.noResultsLabel.text = error.localizedDescription
                return Just([])
            }.sink(receiveValue: { values in
                self.viewModel?.todoList = values
                self.updateTable(with: values)
            }).store(in: &cancellables)
        
        viewModel?.$searchList
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] values in
                guard let this = self, let viewModel = this.viewModel else { return }
                if values.isEmpty {
                    this.updateTable(with: viewModel.todoList)
                } else {
                    this.updateTable(with: values)
                }
            })
            .store(in: &cancellables)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        itemSelectedPublisher.send(item.idLeague)
    }
}

private extension SearchViewController {
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .lightGray
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
    }

    func setupNoResults() {
        let label = UILabel()
        label.text = "No ToDos Found!\n Please try different name again..."
        label.sizeToFit()
        label.isHidden = true
        tableView.backgroundView = label
        noResultsLabel = label
    }

    func setupDataSource() {
        tableView.register(LeagueTableCell.self)
        snapshot.appendSections([.main])
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, item) -> LeagueTableCell? in
                let cell = tableView.dequeue(cell: LeagueTableCell.self, forIndexPath: indexPath)
                cell.viewModel = LeagueTableCellVM(dataAPI: item)
                return cell
            })
    }
    
    func updateTable(with items: [ToDo]) {
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

//
//  ToDoListViewController.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa
import Domain

class ToDoListViewController: UIViewController {
    // MARK: - Enums and Type aliases
    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ToDo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ToDo>
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private weak var refreshControl: UIRefreshControl!
    private weak var noResultsLabel: UILabel!
    private var dataSource: DataSource!
    private var snapshot: Snapshot = .init()
    
    var viewModel: ToDoListViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var itemSelectedPublisher: PassthroughSubject<String, Never> = .init()

    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        tableView.delegate = self
        setupRefreshControl()
        setupNoResults()
        setupDataSource()
        
        let viewModelInput = ToDoListViewModel.Input(
            refresh: Publishers.ControlEvent(control: refreshControl, events: .valueChanged)
                .map { _ in () }
                .prepend(())
                .eraseToAnyPublisher(),
            itemSelected: itemSelectedPublisher
                .eraseToAnyPublisher(),
            loadMore: tableView.reachedBottomPublisher()
                .debounce(for: 0.1, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        )
        
        let viewModelOutput = viewModel?.transform(viewModelInput)
        
        viewModelOutput?.results.receive(on: DispatchQueue.main)
            .catch { [weak self] error -> Just<[ToDo]> in
                self?.noResultsLabel.text = error.localizedDescription
                return Just([])
            }.sink(receiveValue: { values in
                self.updateTable(with: values)
            }).store(in: &cancellables)
    }
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        itemSelectedPublisher.send(item.idLeague)
    }
}

private extension ToDoListViewController {
    
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

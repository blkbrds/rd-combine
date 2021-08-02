//
//  SearchViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/31/21.
//

import UIKit
import Combine

final class SearchViewController: ViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    var cellsSubscription: [IndexPath : AnyCancellable] = [:]
    var viewModel: SearchViewModel = SearchViewModel()
    let loadMoreSubject = PassthroughSubject<Void, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

         title = "SEARCH"
    }

    override func setupUI() {
        super.setupUI()

        tableView.register(SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func binding() {
        super.binding()

        viewModel.state
            .sink { [weak self] state in
                switch state {
                case .error(let message):
                    _ = self?.alert(text: message)
                default: break
                }
            }
            .store(in: &subscriptions)

        searchTextField.textPublisher
            .assign(to: \.keyword, on: viewModel)
            .store(in: &subscriptions)

        viewModel.$listGameSearched
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }

    override func setupData() {
        super.setupData()
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.state.send(.loadMore)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - 700) {
            viewModel.state.send(.loadMore)
        }
        if tableView.contentOffset.y == 0 {
            viewModel.state.send(.refresh)
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SearchCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

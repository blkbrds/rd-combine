//
//  TopViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/12/21.
//

import UIKit
import Combine

final class TopViewController: ViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    private var viewModel: TopViewModel = TopViewModel()
    var cellsSubscription: [IndexPath : AnyCancellable] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TOP"
    }

    override func setupUI() {
        super.setupUI()
        // Config table view
        tableView.register(StoreCell.self)
        tableView.delegate = self
        tableView.dataSource = self

        viewModel.state
            .sink { [weak self] state in
                switch state {
                case .error(let message):
                    _ = self?.alert(text: message)
                default:
                    break
                }
            }
        .store(in: &subscriptions)
    }

    override func binding() {
        super.binding()

        viewModel.$gameStores
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { value in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }

    override func setupData() {
        super.setupData()

        viewModel.getData()
    }
}

// MARK: - UITableViewDelegate
extension TopViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = viewModel.gameStores[indexPath.row]
        let vc = StoreDetailViewController()
        vc.viewModel = StoreDetailViewModel(store: store)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TopViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: StoreCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.getCategoryCellVM(at: indexPath) as? StoreCellViewModel
        return cell
    }
}

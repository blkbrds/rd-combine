//
//  StoreDetailViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import UIKit
import Combine

final class StoreDetailViewController: ViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: StoreDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
        
        tableView.register(StoreDetailCell.self)
        tableView.register(GamePerStoreCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func binding() {
        super.binding()

        guard let viewModel = viewModel else { return }
        viewModel.$storeDetail
            .dropFirst()
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { value in
                self.tableView.reloadSections([0], with: .automatic)
            }
            .store(in: &subscriptions)
    }

    override func setupData() {
        super.setupData()

        guard let viewModel = viewModel else { return }
        viewModel.getStoreDetail()
    }
}

// MARK: - UITableViewDataSource
extension StoreDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let sectionType = viewModel.getSectionType(at: indexPath)
        switch sectionType {
        case .storeDetail:
            let cell = tableView.dequeue(cell: StoreDetailCell.self, forIndexPath: indexPath)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? StoreDetailCellViewModel
            return cell
        default:
            let cell = tableView.dequeue(cell: GamePerStoreCell.self, forIndexPath: indexPath)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? GamePerStoreCellViewModel
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension StoreDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, let games = viewModel.store.games else { return }
        let vc = GameDetailViewController()
        vc.viewModel = GameDetailViewModel(id: games[indexPath.row].id, gameName: games[indexPath.row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  HomeVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import UIKit
import Combine

private struct Configure {
    static let identifier = String(describing: "HomeViewCell")
}

final class HomeVC: UIViewController {

    typealias DataSource = UITableViewDiffableDataSource<String, Cook>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Cook>

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    var viewModel: HomeViewModel!
    private var dataSource: DataSource!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        configDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Private functions
    private func configTableView() {
        let nib = UINib(nibName: Configure.identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: Configure.identifier)
        tableView.delegate = self
    }

    private func configDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, cook) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: Configure.identifier) as? HomeViewCell
            cell?.vm = HomeViewCellVM(cook: cook)
            return cell
        })
        
        viewModel.$isLoading
            .map({ !$0 })
            .print()
            .assign(to: \.isHidden, on: indicatorView)
            .store(in: &viewModel.stores)

        viewModel?.$cooks
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { cooks in
                var snapShot = Snapshot()
                snapShot.appendSections(["section1"])
                snapShot.appendItems(cooks, toSection: "section1")
                self.dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
            })
            .store(in: &viewModel.stores)

        viewModel.$searchKeyword
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .share()
            .sink { value in
                self.viewModel.getCookings(type: .lists(value))
            }.store(in: &viewModel.stores)

    }

    // MARK: - IBActions
    @IBAction private func searchTextFieldEdittingChange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            viewModel.searchKeyword = text
        } else {
            viewModel.searchKeyword = ""
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.cooks[indexPath.row]
        let vc = DetailVC()
        vc.viewModel = DetailViewModel(cook: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

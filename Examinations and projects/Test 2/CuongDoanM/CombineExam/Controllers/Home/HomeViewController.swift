//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var subscriptions: Set<AnyCancellable> = []
    private let identifier = String(describing: "HomeCell")
    private lazy var dataSource: UITableViewDiffableDataSource<Int, Drink> = createDataSource()
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let nib: UINib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = dataSource
        
        bindViewModelToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction private func searchTextFieldEditingChanged(_ sender: UITextField) {
        viewModel?.keyword.send(sender.text.orEmpty)
    }
    
    private func bindViewModelToView() {
        guard let viewModel: HomeViewModel = viewModel else { return }
        viewModel.drinks
            .sink { [weak self] drinks in
                guard let this = self else { return }
                this.update(with: drinks)
            }
            .store(in: &subscriptions)
        viewModel.error
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let this = self else { return }
                let alert: UIAlertController = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
                let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    this.bindViewModelToView()
                }
                alert.addAction(ok)
                this.present(alert, animated: true)
            }
            .store(in: &subscriptions)
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<Int, Drink> {
        UITableViewDiffableDataSource<Int, Drink>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, drink in
                guard let cell: HomeCell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as? HomeCell else {
                    fatalError()
                }
                cell.update(drink: drink)
                return cell
            }
        )
    }
    
    private func update(with drinks: [Drink], animated flag: Bool = true) {
        var snapshot: NSDiffableDataSourceSnapshot<Int, Drink> = NSDiffableDataSourceSnapshot<Int, Drink>()
        snapshot.appendSections([0])
        snapshot.appendItems(drinks, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: flag)
    }
}

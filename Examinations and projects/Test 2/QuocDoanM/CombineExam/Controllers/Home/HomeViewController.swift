//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    typealias DataSource = UITableViewDiffableDataSource<String, Cocktail>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Cocktail>
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    let identifier = String(describing: "HomeViewCell")
    private var diffableDataSource: UITableViewDiffableDataSource<Cocktail, Never>!
    var viewModel: HomeViewModel = HomeViewModel()
    private var dataSource: DataSource!
    
    var publisher = PassthroughSubject<String, Never>()
    private var stores: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, cocktail) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? HomeViewCell else { return UITableViewCell() }
            cell.viewModel = HomeViewCellViewModel(cocktail: cocktail)
            return cell
        })

        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupBindings() {
        searchTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.keyword, on: viewModel)
            .store(in: &stores)

        viewModel.$cocktails
            .receive(on: DispatchQueue.main)
            .sink { cocktail in
                var snapshot = Snapshot()
                snapshot.appendSections(["section1"])
                snapshot.appendItems(cocktail, toSection: "section1")
                self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
            }
            .store(in: &stores)
    }
}

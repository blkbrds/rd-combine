//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
   
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    // MARK: - Properties
    let identifier = String(describing: "HomeViewCell")

    var subscriptions = Set<AnyCancellable>()

    var viewModel = HomeViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Private
    private func bindViewModel() {
        searchTextField.publisher
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .assign(to: \.keyword, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.users.sink { [weak self] users in
            guard let this = self else { return }
            this.reloadData()
        }.store(in: &subscriptions)
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
}

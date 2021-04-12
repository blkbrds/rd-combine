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
    let identifier = String(describing: "HomeCell")
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
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
        viewModel.searchResult
            .sink { [weak self] _ in
                guard let this = self else { return }
                this.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel: HomeViewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeCell else {
            fatalError()
        }
        if let user: User = viewModel?.getUser(at: indexPath) {
            cell.updateUI(user: user)
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

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
    @IBOutlet weak var searchTextField: UITextField!
    let identifier = String(describing: "HomeViewCell")
    
    var viewModel: HomeViewModel?
    var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        if let viewModel = viewModel {
            searchTextField.publisher
                .compactMap { $0 }
                .assign(to: \.searchText, on: viewModel)
                .store(in: &subscriptions)
            viewModel.users
                .sink { [weak self] _ in
                    self?.tableView.reloadData()
                }
                .store(in: &subscriptions)
        }
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell, let user = viewModel?.users.value[indexPath.row] else {
            fatalError()
        }
        cell.nameLabel.text = user.name
        cell.addressLabel.text = user.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.users.value.count ?? 0
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

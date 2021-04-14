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
    let searchPublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        searchPublisher.sink { value in
            self.viewModel.users = LocalDatabase.users
            self.viewModel.users = self.viewModel.users.filter { user in
                user.name.uppercased().contains(value.uppercased())
            }
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func searchTextFieldEdittingChange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            searchPublisher.send(text)
        } else {
            viewModel.users = LocalDatabase.users
            tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.updateUI(viewModel.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

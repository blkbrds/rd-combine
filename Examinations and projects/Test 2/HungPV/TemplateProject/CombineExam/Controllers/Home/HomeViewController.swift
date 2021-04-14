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
    @IBOutlet private weak var searchTextField: UITextField!

    let identifier = String(describing: "HomeViewCell")
    var subcriptions = Set<AnyCancellable>()
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        searchTextField.textPublisher
            .dropFirst()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] text in
                guard let this = self else { return }
                this.viewModel.filterUsers = text.isEmpty ? this.viewModel.users : this.viewModel.users.filter({ (values) -> Bool in
                    return values.name.range(of: text, options: .caseInsensitive) != nil
                })
                this.tableView.reloadData()
            })
            .store(in: &subcriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell
        else {
            fatalError()
        }
        let users = viewModel.getUser(with: indexPath)
        let cellViewModel = HomeViewCellModel(users: users)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalDatabase.users.count
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

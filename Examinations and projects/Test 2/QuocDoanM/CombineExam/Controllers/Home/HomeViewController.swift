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
    
    var viewModel: HomeViewModel = HomeViewModel()
    var publisher = PassthroughSubject<String, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        searchTextField.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        searchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func searchUser() {
        publisher
            .sink(receiveValue: { value in
                self.viewModel.keyword = value
                self.viewModel.searchList.removeAll()
                self.viewModel.users.forEach { user in
                    if user.name.lowercased().contains(value.lowercased()) {
                        self.viewModel.searchList.append(user)
                    }
                }
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        publisher.send(textField.text ?? "")
    }
}

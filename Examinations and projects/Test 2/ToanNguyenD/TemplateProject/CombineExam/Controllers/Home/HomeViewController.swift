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
    
    var viewModel: HomeViewModel?
    var publisher = PassthroughSubject<String, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        searchTextField.delegate = self
        searchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func searchUser() {
        publisher
            .sink(receiveValue: { value in
                self.viewModel?.searchtext = value
                self.viewModel?.userSearchList.removeAll()
                self.viewModel?.userList.forEach { user in
                    if user.name.lowercased().contains(value.lowercased()) {
                        self.viewModel?.userSearchList.append(user)
                    }
                }
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let cell = dequeuedCell as? HomeViewCell else {
            fatalError("Could not dequeue a cell")
        }
        cell.viewModel = viewModel?.itemOfCell(in: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
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

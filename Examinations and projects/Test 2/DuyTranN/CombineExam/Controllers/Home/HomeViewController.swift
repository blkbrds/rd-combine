//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    let identifier = String(describing: "HomeViewCell")
    var viewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        searchTextField.addTarget(self,
                                  action: #selector(textFieldEditingChanged(textField:)),
                                  for: .editingChanged)

        viewModel.searchInputSubject
            .sink(receiveValue: { [weak self] _ in
                guard let this = self else { return }
                this.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - IBActions
    @objc private func textFieldEditingChanged(textField: UITextField) {
        viewModel.searchInputSubject.send(textField.value)
    }
}

// MARK: - Extension UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError()
        }
        let cellVM = viewModel.viewModelForHomeViewCell(at: indexPath)
        (cell as? HomeViewCell)?.updateView(with: cellVM)
        return cell
    }
}

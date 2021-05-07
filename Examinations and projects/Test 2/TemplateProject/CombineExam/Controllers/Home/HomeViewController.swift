//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @Published private var _searchString: String = ""
    
    let identifier = String(describing: "HomeViewCell")
    var viewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        searchInput.addTarget(self,
                                  action: #selector(textFieldEditingChanged(textField:)),
                                  for: .editingChanged)

        viewModel.searchInput
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: { [weak self] _ in
                guard let this = self else { return }
                this.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }

    @objc private func textFieldEditingChanged(textField: UITextField) {
        viewModel.searchInput.send(textField.value)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

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

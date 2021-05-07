//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    let identifier = String(describing: "HomeViewCell")
    
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: nil)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
            .sink { (text) in
                viewModel.searchBy(keyword: text)
                self.tableView.reloadData()
            }
            .store(in: &viewModel.subscription)
        
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell,
              let viewModel = viewModel else {
            fatalError()
        }
        cell.viewModel = HomeViewCellModel(userName: viewModel.users[indexPath.row].name, address: viewModel.users[indexPath.row].address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.users.count ?? 0
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

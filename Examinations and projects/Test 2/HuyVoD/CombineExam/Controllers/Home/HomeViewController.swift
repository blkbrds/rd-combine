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
    
    
    let identifier = String(describing: "HomeViewCell")
    
    var viewModel: HomeViewModel?
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        configSubscription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func searchTextFieldEdittingChanged(_ sender: UITextField) {
        viewModel?.searchKey.send(sender.text ?? "")
    }
    
    private func configSubscription() {
        viewModel?.drinks.sink(receiveValue: { [weak self] _ in
            self?.tableView.reloadData()
        }).store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.drink = viewModel?.drinks.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.drinks.value.count ?? 0
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

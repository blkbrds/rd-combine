//
//  HomeViewController.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/13/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Combine
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!

    let identifier = String(describing: "HomeViewCell")

    var viewModel: HomeViewModel?
    var subcripstions = Set<AnyCancellable>()
    var inputPublisher = PassthroughSubject<String,Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        searchName()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func searchEditingChanged(_ sender: Any) {
        guard let searchText = searchTextField.text else { return }
        inputPublisher.send(searchText)
        tableView.reloadData()
    }

    func searchName() {
        guard let viewModel = viewModel else { return }
        inputPublisher.sink(receiveCompletion: { completion in
            print(completion)
        }) { (value) in
            viewModel.filterPublisher.map { user in
                user.filter { user in
                    user.name.lowercased().hasPrefix(value.lowercased())
                }
            }
            .sink { user in
                viewModel.resultList = user
            }
        }
        .store(in: &subcripstions)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell, let viewModel = viewModel else {
            fatalError()
        }
        cell.viewModel = viewModel.viewModelForCell(indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.resultList.count
    }
}

extension HomeViewController: UITableViewDelegate {

}

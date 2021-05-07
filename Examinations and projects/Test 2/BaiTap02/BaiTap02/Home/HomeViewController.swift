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
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    let identifier = String(describing: "HomeViewCell")

    var viewModel: HomeViewModel = HomeViewModel()
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

        searchTextField.publisher
            .compactMap{ $0 }
            .assign(to: \.searchText, on: viewModel)
            .store(in: &subcripstions)
        viewModel.filterPublisher
            .sink { [weak self] _ in
                self?.isLoading()
        }
        .store(in: &subcripstions)
    }

    func isLoading() {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
            self.indicatorView.stopAnimating()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.bindView(to: viewModel, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterPublisher.value.count
    }
}

extension HomeViewController: UITableViewDelegate {

}

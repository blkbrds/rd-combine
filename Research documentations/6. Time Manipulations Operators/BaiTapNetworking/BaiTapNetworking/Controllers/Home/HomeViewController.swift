//
//  HomeViewController.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel: HomeViewModel = HomeViewModel()
    var subcripstions = Set<AnyCancellable>()
    let identifier = String(describing: "HomeViewCell")

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        viewModel.getNameProvince()
        configTableView()

        viewModel.provinceSubject
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &subcripstions)
    }

    // MARK: - Private functions
    private func configTableView() {
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        let province = viewModel.provinceSubject.value[indexPath.row]
        cell.nameLabel.text = province.name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.provinceSubject.value.count
    }
}
extension HomeViewController: UITableViewDelegate {

}

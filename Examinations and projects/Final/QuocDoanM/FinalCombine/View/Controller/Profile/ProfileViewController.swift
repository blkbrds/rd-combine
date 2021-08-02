//
//  ProfileViewController.swift
//  FinalCombine
//
//  Created by Quoc Doan M. VN.Danang on 7/15/21.
//

import UIKit

final class ProfileViewController: ViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: ProfileViewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PROFILE"
    }

    override func setupUI() {
        super.setupUI()

        tableView.register(UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCells()
        tableView.isScrollEnabled = false
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected at: ", viewModel.others[indexPath.row].title)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.others.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: UITableViewCell.self, forIndexPath: indexPath)
        cell.textLabel?.text = viewModel.others[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
}

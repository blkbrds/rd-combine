//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    let identifier = String(describing: "HomeViewCell")

    var viewModel: HomeViewModel?
    private var bindings = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupBindings()
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController {
    func setupBindings() {
        bindViewToViewModel()
        bindViewModelToView()
    }

    func bindViewToViewModel() {
        guard let viewModel = viewModel else { return }
        searchTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchText, on: viewModel)
            .store(in: &bindings)
    }

    func bindViewModelToView() {
        guard let viewModel = viewModel else { return }
        viewModel.searchResult
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { _ in
                self.tableView.reloadData()
            })
            .store(in: &bindings)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier)  as? HomeViewCell else {
            fatalError()
        }
        let user = viewModel.users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.addressLabel.text = user.address
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.users.count
    }
}

extension HomeViewController: UITableViewDelegate {

}

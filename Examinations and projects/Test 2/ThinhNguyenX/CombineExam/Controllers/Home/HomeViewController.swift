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
    private var subscriptions = Set<AnyCancellable>()
    var cellsSubscription: [IndexPath : AnyCancellable] = [:]
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        bindingToView()
        bindingToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func bindingToView() {
        viewModel.$keyWord
          .assign(to: \.text, on: searchTextField)
          .store(in: &subscriptions)

        viewModel.$users
              .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
              .sink(receiveValue: { _ in
                print("binding table : \(self.viewModel.numberOfRows(in: 1))")
                self.cellsSubscription.removeAll()
                self.tableView.reloadData()
              })
              .store(in: &subscriptions)
    }

    private func bindingToViewModel() {
        // searchTextField
        searchTextField.publisher
            .assign(to: \.keyWord, on: viewModel)
            .store(in: &subscriptions)

        /// `TEST` real time
        viewModel.$keyWord
            .sink { print($0)}
            .store(in: &subscriptions)

        // cell
        viewModel.state
            .sink { [weak self] state in
                if case .reloadCell(let indexPath) = state {
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                }

            }
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
           return HomeViewCell()
        }

        let vm = viewModel.userCellViewModel(at: indexPath)
        cell.viewModel = vm
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

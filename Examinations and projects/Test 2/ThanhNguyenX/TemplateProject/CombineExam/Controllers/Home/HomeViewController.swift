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
    
    var viewModel: HomeViewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()
    let searchSubject = PassthroughSubject<String, SignInError>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        searchTextField.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        getAPI()
        searchSubject
            .sink { completion in
                print(completion)
            } receiveValue: { searchText in
//                self.viewModel.filteredUser = searchText.isEmpty ? self.viewModel.users : self.viewModel.users.filter({ (user) -> Bool in
//                    user.nameTitle.range(of: searchText, options: .caseInsensitive) != nil
//                })
//                self.tableView.reloadData()
                self.getAPI(searchText: searchText)
                print(searchText)
            }
            .store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func getAPI(searchText: String = "") {
        viewModel.getAPI(searchText: searchText)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("ERROR:", error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.viewModel = HomeViewCellVM(name: viewModel.filteredUser[indexPath.row].nameTitle,
                                        address: viewModel.filteredUser[indexPath.row].instructions)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchSubject.send(textField.text ?? "")
    }
}

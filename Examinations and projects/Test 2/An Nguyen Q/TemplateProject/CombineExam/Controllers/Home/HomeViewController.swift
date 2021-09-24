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
    @IBOutlet weak var searchTextField: UITextField!
    let identifier = String(describing: "HomeViewCell")
    let searchPublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        getListDrinks()
        searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .share()
            .sink { value in
            self.getListDrinks(value)
        }.store(in: &subscriptions)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func searchTextFieldEdittingChange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            searchPublisher.send(text)
        } else {
            searchPublisher.send("")
        }
    }
    
    private func getListDrinks(_ search: String = "") {
        viewModel.getListDrinks(search)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { _ in
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        cell.updateUI(viewModel.drinks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

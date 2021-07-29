//
//  HomeViewController.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    let identifier = String(describing: "HomeViewCell")
    var networking = Networking()
    var drinks: [Drink] = []

    var viewModel: HomeViewModel?
    var sub = Set<AnyCancellable>()
    var searchUserDatas: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        searchUserDatas = LocalDatabase.users
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        setupPublisher()
        listener()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupPublisher() {
        self.networking.fetchData()
            .sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { (data) in
                self.drinks = data.drinks
                self.tableView.reloadData()
        }).store(in: &sub)
    }

    func listener() {
        let pub = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
        pub
            .map {
            (($0.object as! UITextField).text ?? "")
        }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { (noti) in
            self.searchText(searchText: noti)
        }.store(in: &sub)
    }

    func searchText(searchText: String) {

        self.networking.search(searchKey: searchText)
            .sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { (data) in
                self.drinks = data.drinks
                self.tableView.reloadData()
            }).store(in: &self.sub)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeViewCell else {
            fatalError()
        }
        let drink = drinks[indexPath.row]
        cell.data = DrinkData(name: drink.strDrink, thumnailImage: drink.strDrinkThumb, address: drink.strGlass)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
}

extension HomeViewController: UITableViewDelegate {

}

//
//  CockTaiVC.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/18/21.
//

import UIKit
import Combine

class CockTaiVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    private var webservice = Networking()
    private var cancellable: AnyCancellable?
    private var cancellabelSearch: AnyCancellable?
    private var subscription: Set<AnyCancellable> = []
    private var drinks = [Drinks]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupPublisher()
        searchPublisher()
    }

    private func setupPublisher() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.cancellable = self.webservice.fetchData()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { (drinks) in
                self.drinks = drinks.drinks
            self.tableView.reloadData()
            })
    }

    private func searchPublisher() {
        self.cancellable = searchTextField.publisherSearch
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { (drinks) in
                self.webservice.search(searchKey: drinks ?? "a")
                    .sink(receiveCompletion: { completion in
                        print(completion)
                    }, receiveValue: { (drinks) in
                        self.drinks = drinks.drinks
                        self.tableView.reloadData()
                    }).store(in: &self.subscription)
            })

    }

}

extension CockTaiVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let drink = self.drinks[indexPath.row]
        cell.textLabel?.text = drink.strDrink

        return cell
    }
}

extension UITextField {
    var publisherSearch: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap {
                $0.object as? UITextField?
            }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}

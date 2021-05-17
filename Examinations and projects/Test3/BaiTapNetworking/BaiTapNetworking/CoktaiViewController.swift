//
//  CoktaiViewController.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/8/21.
//

import Foundation
import UIKit
import Combine

class CoktaiViewController: UITableViewController, UISearchBarDelegate {

    private var webservice = Networking()
    private var cancellable: AnyCancellable?
    private var cancellabelSearch: AnyCancellable?

    @Published var searchKey = ""

    private var drinks = [Drinks]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPublisher()
    }

    private func setupPublisher() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.cancellable = self.webservice.fetchData()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { (drinks) in
                self.drinks = drinks.drinks
            })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cancellabelSearch = $searchKey.removeDuplicates()
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { (string) in
                if string == ""
                {

                } else {
                    print(string)
                }
            })
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("!!!trungsearchText \(String(describing: searchBar.text))")
        }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = self.drinks[indexPath.row]
        cell.textLabel?.text = post.strAlcoholic

        return cell
    }

}

extension UITextField {
  var publisher: AnyPublisher<String?, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap {
        $0.object as? UITextField?
      }
      .map { $0?.text }
      .eraseToAnyPublisher()
  }
}

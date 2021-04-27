//
//  HomeViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<String, User>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, User>
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    let identifier = String(describing: "HomeViewCell")
    
    var viewModel: HomeViewModel!
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as? HomeViewCell
            cell?.vm = HomeViewCellVM(user: user)
            return cell
        })
        
        viewModel?.$users
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { users in
                var snapShot = Snapshot()
                snapShot.appendSections(["section1"])
                snapShot.appendItems(users, toSection: "section1")
                self.dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
            })
            .store(in: &viewModel.stores)
        
        searchTextField.publisher(for: .editingChanged)
            .compactMap { $0.text }
            .assign(to: \.searchKeyword, on: viewModel)
            .store(in: &viewModel.stores)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension UIImageView {
    
    func setImage(_ imageURL: String, placeholder image: UIImage? = nil) -> AnyCancellable? {
        guard let url = URL(string: imageURL) else {
            return nil
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in
                guard let image = UIImage(data: data) else {
                    return nil
                }
                return image
            }
            .replaceError(with: image)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

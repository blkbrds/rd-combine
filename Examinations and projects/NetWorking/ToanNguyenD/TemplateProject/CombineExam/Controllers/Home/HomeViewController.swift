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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    let identifier = String(describing: "HomeViewCell")
    
    var viewModel: HomeViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setUpBindings() {
        guard let viewModel = viewModel else { return}
        func bindViewToViewModel() {
            searchTextField.textPublisher
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.searchText, on: viewModel)
                .store(in: &subscriptions)
        }

        func bindViewModelToView() {
            let viewModelsValueHandler: ([HomeCellViewModel]) -> Void = { [weak self] _ in
                self?.tableView.reloadData()
            }

            viewModel.$cocktailViewModels
                .receive(on: RunLoop.main)
                .sink(receiveValue: viewModelsValueHandler)
                .store(in: &subscriptions)

            let stateValueHandler: (HomeViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.startLoading()
                case .finishedLoading:
                    self?.finishLoading()
                case .error(let error):
                    self?.finishLoading()
                    self?.showError(error)
                }
            }

            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &subscriptions)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    private func startLoading() {
        tableView.isUserInteractionEnabled = false
        searchTextField.isUserInteractionEnabled = false

        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    private func finishLoading() {
        tableView.isUserInteractionEnabled = true
        searchTextField.isUserInteractionEnabled = true

        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }

    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let cell = dequeuedCell as? HomeViewCell else {
            fatalError("Could not dequeue a cell")
        }
        cell.viewModel = viewModel?.cocktailViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.cocktailViewModels.count
    }
}

//
//  HomeViewController.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import UIKit
import Combine
import SwiftUI

final class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - Private properties
    let identifier = String(describing: "HomeCell")
    let searchPublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        bindViewModelToView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Private functions
    private func bindViewModelToView() {
        // sink data
        viewModel.drinks.sink { completion in
            switch completion {
            case .failure(let error):
                self.viewModel.error.value = error
            case .finished: break
            }
        } receiveValue: { drinks in
            self.tableView.reloadData()
        }.store(in: &subscriptions)

        // sink error
        var retryCount: Int = 1
        viewModel.error
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let this = self else { return }
                let alert: UIAlertController = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
                let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // TODO: - call retry api
                    let _ = apiProvider.request(.search(this.viewModel.keyword.value))
                        .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
                        .map(\.data)
                        .decode(type: APIResponse<Drink>.self, decoder: JSONDecoder())
                        .handleEvents( receiveCompletion: {(completion) in
                            switch completion {
                            case .finished:
                                print("Success")
                                retryCount = 1
                            case .failure(_):
                                print("Đang kết nối lại \(retryCount)/3")
                                retryCount += 1
                            }
                        })
                        .retry(2)
                        .catch {(err) -> AnyPublisher<APIResponse<Drink>, Error>  in
                            switch err {
                            case APIError.errorParsing:
                                print("APIError.errorParsing")
                            case APIError.errorURL:
                                print("APIError.errorURL")
                            case APIError.invalidResponse:
                                print("APIError.invalidResponse")
                            default:
                                print("unknown")
                            }
                            return apiProvider.request(.listall(""))
                                .receive(on: RunLoop.main)
                                .map(\.data)
                                .decode(type: APIResponse<Drink>.self, decoder: JSONDecoder())
                                .eraseToAnyPublisher()
                        }
                        .compactMap({ value -> [Drink]? in
                            return value.drinks
                        })
                        .replaceError(with: this.viewModel.drinks.value)
                        .sink {(err) in
                        } receiveValue: {(output) in
                            retryCount = 1
                            this.viewModel.drinks.value = output                   }.store(in: &this.subscriptions)
                }
                alert.addAction(ok)
                this.present(alert, animated: true)
            }
            .store(in: &subscriptions)

        // search
        searchPublisher.debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .share()
            .sink(receiveCompletion: { [weak self] completion in
                guard let this = self else { return }
                if case .failure(let error) = completion {
                    switch error {
                    case URLError.badURL:
                        this.viewModel.error.value = APIError.errorURL
                    case URLError.badServerResponse:
                        this.viewModel.error.value = APIError.invalidResponse
                    case URLError.cannotParseResponse:
                        this.viewModel.error.value = APIError.errorParsing
                    default:
                        this.viewModel.error.value = APIError.unknown
                    }
//                    this.viewModel.error.value = error
                }
            }, receiveValue: { value in
                self.viewModel.keyword.value = value
                self.viewModel.getListDrinks(.search(value))
            }).store(in: &subscriptions)
    }

    private func configUI() {
        title = "Home"
        view.backgroundColor = .orange
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - IBActions
    @IBAction private func searchTextFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            searchPublisher.send(text)
        } else {
            searchPublisher.send("")
        }
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeCell else {
            fatalError()
        }
        cell.updateUI(viewModel.drinks.value[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.value.count
    }
}

extension HomeViewController: UITableViewDelegate { }

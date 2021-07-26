//
//  MusicListViewController.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

import UIKit
import FirebaseAuth
import Combine

final class MusicListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let viewModel = MusicListViewModel()
    var subscriptions = Set<AnyCancellable>()
    let searchPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Musics"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "User", style: .plain, target: self, action: #selector(goToDetailUser))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        configUI()
        configTableView()
        bindingCombine()
        getMusicList(viewModel.limited)
    }
    
    // MARK: - Private funcs
    private func configTableView() {
        tableView.register(UINib(nibName: "MusicTableViewCell", bundle: .main), forCellReuseIdentifier: "musicCell")
        tableView.register(UINib(nibName: "LoadmoreTableViewCell", bundle: .main), forCellReuseIdentifier: "loadmoreCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func bindingCombine() {
        searchPublisher
//            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
//            .share()
            .sink { [weak self] val in
                guard let this = self else { return }
                if val.isEmpty {
                    this.viewModel.musicsList = this.viewModel.allMusicsList
                } else {
                    this.viewModel.musicsList = this.viewModel.allMusicsList.filter({ $0.name.lowercased().contains(val.lowercased()) })
                }
                this.viewModel.isSearch = !val.isEmpty
                this.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    private func configUI() {
        indicator.isHidden = true
    }
    
    private func getMusicList(_ limit: Int) {
        indicator.isHidden = false
        indicator.startAnimating()
        
        viewModel.getMusicList(limit)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.showError(error.localizedDescription )
                }
                
            }, receiveValue: { _ in
                self.tableView.reloadData()
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Objc
    @objc private func goToDetailUser() {
        let vc = UserDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logout() {
        indicator.isHidden = false
        indicator.startAnimating()
        do {
            try Auth.auth().signOut()
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.changeRoot()
            }
        } catch {
            indicator.isHidden = true
            indicator.stopAnimating()
            showError(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDelegate
extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = viewModel.musicsList[indexPath.row]
        let vc = MusicDetailViewController()
        vc.viewModel = MusicDetailViewModel(music: music)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension MusicListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.musicCells[indexPath.row] {
        case .music:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? MusicTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel.getMusicTableViewCellModel(indexPath.row)
            return cell
        case .loadmore:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loadmoreCell", for: indexPath) as? LoadmoreTableViewCell else {
                return UITableViewCell()
            }
            cell.subscriptions.removeAll()
            cell.loadmorePublisher?
                .sink(receiveValue: { _ in
                    self.viewModel.limited += 10
                    print("====> limited:", self.viewModel.limited)
                    self.getMusicList(self.viewModel.limited)
                })
                .store(in: &cell.subscriptions)
            return cell
        }
    }
}

// MARK: - UISearchBarDelegate
extension MusicListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPublisher.send(searchText)
    }
}

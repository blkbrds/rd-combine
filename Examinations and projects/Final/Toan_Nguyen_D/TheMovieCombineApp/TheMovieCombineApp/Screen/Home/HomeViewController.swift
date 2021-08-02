//
//  HomeViewController.swift
//  TheMovieCombineApp
//
//  Created by Hoa Nguyen X. [2] VN.Danang on 29/07/2021.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        configSearchBar()
        registerCell()
        applySearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func config() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }

    private func registerCell() {
        collectionView.register(UINib(nibName: "MovieCell", bundle: .main), forCellWithReuseIdentifier: "MovieCell")
    }

    private func configSearchBar() {
        searchBar.publisher(for: \.text)
            .receive(on: RunLoop.main)
            .assign(to: \.searchText, on: viewModel)
            .store(in: &viewModel.subscriptions)
    }

    private func applySearch() {
        viewModel.$movies.sink { [weak self] (movie) in
            print(movie.count)
            if movie.count <= 20 {
                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
            self?.collectionView.reloadData()
        }.store(in: &viewModel.subscriptions)
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberRowOfSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell
        cell?.viewModel = viewModel.getCellForRow(indexPath: indexPath)
        return cell ?? UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height + 10 {
            if !viewModel.isLoading.value {
                viewModel.isLoading.value = true
            }
        } else {
            viewModel.isLoading.value = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController()
        vc.viewModel = MovieDetailsViewModel(movie: viewModel.movies[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 5
        let height = width * 3 / 2
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
    }
}

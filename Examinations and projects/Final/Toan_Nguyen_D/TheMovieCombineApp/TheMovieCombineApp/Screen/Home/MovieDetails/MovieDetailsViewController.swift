//
//  MovieDetailsViewController.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 02/08/2021.
//

import UIKit

final class MovieDetailsViewController: UIViewController {

    @IBOutlet private weak var thumbMovieImageView: UIImageView!
    @IBOutlet private weak var titleMovieLabel: UILabel!
    @IBOutlet private weak var ReleaseDateLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var castCollectionView: UICollectionView!
    @IBOutlet private weak var overViewLabel: UILabel!

    var viewModel: MovieDetailsViewModel = MovieDetailsViewModel(movie: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        reloadCastCollectionView()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        viewModel.getListCast()
    }

    private func configUI() {
        titleMovieLabel.text = viewModel.movie?.title ?? ""
        scoreLabel.text = "\(viewModel.movie?.rate ?? 0)"
        overViewLabel.text = viewModel.movie?.overview
        ReleaseDateLabel.text = viewModel.movie?.year
        guard let url = URL(string: viewModel.movie?.poster ?? "") else { return }
        thumbMovieImageView.downloaded(from: url).store(in: &viewModel.subscriptions)
    }

    private func registerCell() {
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.register(UINib(nibName: "CastCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
    }

    private func reloadCastCollectionView() {
        viewModel.$casts.sink(receiveValue: { [weak self] (_) in
            guard let this = self else { return }
            this.castCollectionView.reloadData()
        }).store(in: &viewModel.subscriptions)
    }
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRowForSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CastCell
        cell?.viewModel = viewModel.getCellForRow(indexPath: indexPath)
        return cell ?? UICollectionViewCell()
    }
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

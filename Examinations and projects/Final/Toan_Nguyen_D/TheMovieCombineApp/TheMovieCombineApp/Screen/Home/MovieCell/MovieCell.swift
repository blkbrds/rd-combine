//
//  MovieCell.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 30/07/2021.
//

import UIKit
import Combine

final class MovieCell: UICollectionViewCell {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    @IBOutlet private weak var yearOfMovie: UILabel!

    var viewModel: MovieCellViewModel? {
        didSet {
            autoUpdate()
        }
    }

    private var subscription = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

    private func autoUpdate() {
        guard let viewModel = viewModel else { return }
        titleMovie.text = viewModel.movie?.title
        yearOfMovie.text = viewModel.movie?.overview
        guard let url = URL(string: viewModel.movie?.poster ?? "") else { return }
        posterImageView.downloaded(from: url).store(in: &subscription)
    }

    private func sink() {
        viewModel?.publisher(for: \.movie)
            .sink(receiveValue: { [weak self] (movie) in
            guard let this = self else { return }
            this.titleMovie.text = movie?.title
        }).store(in: &subscription)
    }
}

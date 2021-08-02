//
//  MovieDetailsViewModel.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 02/08/2021.
//

import Foundation
import Combine
final class MovieDetailsViewModel {
    var movie: Movie?
    @Published var casts: [Cast] = []
    var subscriptions = Set<AnyCancellable>()

    init(movie: Movie?) {
        self.movie = movie
    }

    func getRowForSection() -> Int {
        return casts.count
    }

    func getCellForRow(indexPath: IndexPath) -> CastCellViewModel {
        return CastCellViewModel(castName: casts[indexPath.item].name ?? "", profileString: casts[indexPath.item].profileImageString)
    }

    func getListCast() {
        API.Detail.getCast(idMovie: movie?.id ?? 0).sink { (_) in
        } receiveValue: { [weak self] (casts) in
            guard let this = self else { return }
            this.casts = casts
            print("casts.count", casts.count)
        }.store(in: &subscriptions)
    }
}

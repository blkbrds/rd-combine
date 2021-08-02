//
//  HomeViewModel.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 29/07/2021.
//

import Foundation
import Combine

final class HomeViewModel {

    var subscriptions = Set<AnyCancellable>()
    @Published var movies: [Movie] = []
    @Published var searchText: String?
    private var searchCancellable: AnyCancellable?
    private var loadmoreCancellable: AnyCancellable?
    var isLoading = CurrentValueSubject<Bool, Never>(false)

    init() {
        searchMovie()
        loadMore()
    }

    func getCellForRow(indexPath: IndexPath) -> MovieCellViewModel {
        return MovieCellViewModel(movie: movies[indexPath.row])
    }

    func numberRowOfSection() -> Int {
        return movies.count
    }

    func searchMovie() {
        if searchText == nil {
        searchText = "a"
        $searchText
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .sink { [weak self] (text) in
                guard let this = self else { return }
                let newText = text?.replacingOccurrences(of: " ", with: "-") ?? ""
                print("ACB", newText)
                this.searchCancellable?.cancel()
                let tempCancellabel = this.searchCancellable
                this.searchCancellable = API.Search.getMoviesWithSearch(searchKey: newText)
                    .retry(3)
                    .sink { (completion) in
                    print("getMoviesWithSearch: ", completion)
                } receiveValue: { (movies) in
                    print("receiveValue movies: ", movies)
                    this.movies = movies
                }
                this.searchCancellable?.store(in: &this.subscriptions)
                if let temp = tempCancellabel {
                    this.subscriptions.remove(temp)
                }
            }.store(in: &subscriptions)
        }
    }

    func loadMore() {
        isLoading.sink { [weak self] (isLoading) in
            guard let this = self else { return }
            if isLoading {
                this.loadmoreCancellable?.cancel()
                let tempCancellable = this.loadmoreCancellable
                this.loadmoreCancellable = API.Search.getMoviesWithSearch(searchKey: API.Path.Search.key, page: API.Path.Search.page + 1)
                    .retry(3)
                    .sink { (completion) in
                } receiveValue: { (movies) in
                    print("loadmore movies: ", movies)
                    this.movies = this.movies + movies
                }
                this.loadmoreCancellable?.store(in: &this.subscriptions)
                if let temp = tempCancellable {
                    this.subscriptions.remove(temp)
                }
            }
        }.store(in: &subscriptions)
    }
}

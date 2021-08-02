//
//  SearchViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/31/21.
//

import Foundation
import Combine
import UIKit

final class SearchViewModel: ObservableObject {

    enum SearchType: String, CaseIterable {
        case search
        case relateGame
    }

    enum State {
        case initialize
        case refresh
        case loadMore
        case error(message: String)
    }
    
    enum Action {
        case downloadImage(indexPath: IndexPath)
    }
    
    // Action
    let action = PassthroughSubject<Action, Never>()
    // State
    let state = CurrentValueSubject<State, Never>(.initialize)

    private var loadMoreURL: String?
    @Published var keyword: String = ""
    @Published private(set) var listGameSearched: [GameDetailResponse] = []
    @Published var isLoading: Bool = false
    var stores = [AnyCancellable]()

    init() {
        $keyword
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] keyword in
                self?.getData(keyword: keyword)
            }
            .store(in: &stores)

        // state
        state
            .sink { [weak self] state in
                self?.processState(state)
            }.store(in: &stores)
        
        // action
        action
            .sink { [weak self] action in
                self?.processAction(action)
            }.store(in: &stores)
    }

    private func processAction(_ action: Action) { }
    
    // Process State
    private func processState(_ state: State) {
        switch state {
        case .initialize:
            isLoading = false
        case .refresh:
            removeAll()
            getData(keyword: keyword)
        case .loadMore:
            isLoading = true
            loadMore()
        case .error(let error):
            print("Error:", error)
        }
    }

    private func removeAll() {
        listGameSearched.removeAll()
    }
}

// MARK: - Table view
extension SearchViewModel {

    func numberOfRows(in section: Int) -> Int {
        return listGameSearched.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        guard indexPath.row < listGameSearched.count else {
            return  SearchCellViewModel(game: GameDetailResponse())
        }
        return SearchCellViewModel(game: listGameSearched[indexPath.row])
    }
}

// MARK: - APIs
extension SearchViewModel {

    func getData(keyword: String) {
        API.Search.requestSearchGame(type: .search, keyword: keyword)
            .map { $0 }
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .finished:
                    print("Finished Search")
                case .failure(let error):
                    self?.state.send(.error(message: error.localizedDescription))
                }
            }, receiveValue: { [weak self] response in
                if let urlString = response.next {
                    self?.loadMoreURL = urlString
                }
                self?.listGameSearched.append(contentsOf: response.results)
            })
            .store(in: &stores)
    }

    private func loadMore() {
        guard let url: URL = URL(string: (loadMoreURL ?? "")) else {
            return state.send(.error(message: "No get the url for load data"))
        }
        API.Search.requestLoadMoreSearch(url: url)
            .map { $0 }
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .finished:
                    print("Finished Load more")
                case .failure(let error):
                    self?.state.send(.error(message: error.localizedDescription))
                }
            }, receiveValue: { [weak self] response in
                self?.listGameSearched.append(contentsOf: response.results)
                if let urlString = response.next {
                    self?.loadMoreURL = urlString
                }
            })
            .store(in: &stores)
    }
}

//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

//final class HomeViewModel {
//
//    var userList: [User] = LocalDatabase.users
//    var userSearchList: [User] = []
//    var searchtext: String = ""
//
//    func numberOfItem() -> Int {
//        return searchtext.isEmpty ? userList.count: userSearchList.count
//    }
//
//    func itemOfCell(in indexPath: IndexPath) -> HomeCellViewModel {
//        let user: User = searchtext.isEmpty ? userList[indexPath.row] : userSearchList[indexPath.row]
//        let vm = HomeCellViewModel(user: user)
//        return vm
//    }
//}

enum HomeViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

final class HomeViewModel {
    @Published var searchText: String = ""
    @Published private(set) var cocktailViewModels: [HomeCellViewModel] = []
    @Published private(set) var state: HomeViewModelState = .loading

    private let cocktailService: CocktailServiceProtocol
    private var bindings = Set<AnyCancellable>()

    init(cocktailService: CocktailServiceProtocol = CocktailService()) {
        self.cocktailService = cocktailService

        $searchText
            .sink { [weak self] in self?.fetchPlayers(with: $0) }
            .store(in: &bindings)
    }

    func fetchPlayers(with searchTerm: String?) {
        state = .loading

        let searchTermCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error): self?.state = .error(error)
            case .finished: self?.state = .finishedLoading
            }
        }

        let searchTermValueHandler: ([Cocktail]) -> Void = { [weak self] cocktail in
            self?.cocktailViewModels = cocktail.map { HomeCellViewModel(cocktail: $0) }
        }

        cocktailService
            .get(searchTerm: searchTerm)
            .sink(receiveCompletion: searchTermCompletionHandler, receiveValue: searchTermValueHandler)
            .store(in: &bindings)
    }
}

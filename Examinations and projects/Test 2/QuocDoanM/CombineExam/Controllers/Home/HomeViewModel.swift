//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    @Published var cocktails: [Cocktail] = []
    @Published var keyword: String = ""

    var users: [User] = LocalDatabase.users
    var resultPublisher: AnyCancellable?
    private var stores = Set<AnyCancellable>()

    init() {
        resultPublisher = $keyword
            .receive(on: RunLoop.main)
            .sink(receiveValue: { keyword in
                self.getData(with: keyword)
            })
    }

    func numberOfItem() -> Int {
        return cocktails.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> HomeViewCellViewModel {
        return HomeViewCellViewModel(cocktail: cocktails[indexPath.row])
    }

    private func getData(with keyword: String) {
        guard let url: URL = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(keyword)") else {
            return
        }
        URLSessionRequest.shared.getConktailSearchResult(from: url)
            .sink { response in
                self.cocktails = response.drinks
            }
            .store(in: &stores)
    }
}

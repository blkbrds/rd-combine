//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var drinks: CurrentValueSubject<[Drink], Never> = .init([])
    var inputtedTextSubject: PassthroughSubject<String?, Never> = .init()
    var searchFailed: PassthroughSubject<Error?, Never> = .init()
    private var subscriptions = [AnyCancellable]()

    init() {
        inputtedTextSubject
            .replaceNil(with: "")
            .sink { keyword in
                self.search(keyword: keyword)
            }
            .store(in: &subscriptions)
    }

    func search(keyword: String) {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(keyword)") else {
            searchFailed.send(ClientError.unableToCreateRequest)
            return
        }
        url
            .requestApi(Drinks.self)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    self.searchFailed.send(error)
                }
            }, receiveValue: {
                self.drinks.send($0.drinks)
                self.searchFailed.send(nil)
            })
            .store(in: &subscriptions)

    }

    func viewModelForCell(at indexPath: IndexPath) -> HomeCellViewModel? {
        guard indexPath.row < drinks.value.count else { return nil }
        let drink = drinks.value[indexPath.row]
        let vm = HomeCellViewModel(name: drink.name, tags: drink.tags)
        return vm
    }
}

//
//  HomeViewModel.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject, Identifiable {

    // private
    let error: CurrentValueSubject<APIError?, Never> = .init(nil)
    var drinks: CurrentValueSubject<[Drink], APIError> = .init([])
    let keyword: CurrentValueSubject<String, Never> = .init("")

    var subscriptions: AnyCancellable?

    // init
    init() {
//        keyword
//            .throttle(for: 1.0, scheduler: DispatchQueue.main, latest: true)
//            .erasedFlatMap {
//                apiProvider.request(.search($0))
//            }
//            .tryMap(Drink.self)
//            .print("!@#")
//            .sink(receiveCompletion: { [weak self] in
//                    guard let this = self else { return }
//                    if case .failure(let error) = $0 {
//                        this.error.value = error
//                    }
//                }, receiveValue: { [weak self] value in
//                    guard let this = self else { return }
//                    this.drinks.value = value.drinks
//                }
//            )
//            .store(in: &subscriptions)
        getListDrinks(.listall("a"))
    }

    func getListDrinks(_ type: APITarget) {
        
        subscriptions = apiProvider.request(type)
            .receive(on: RunLoop.main)
            .map(\.data).print()
            .decode(type: APIResponse<Drink>.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] in
                guard let this = self else { return }
                if case .failure(let error) = $0 {
                    switch error {
                    case URLError.badURL:
                        this.error.value = APIError.errorURL
                    case URLError.badServerResponse:
                        this.error.value = APIError.invalidResponse
                    case URLError.cannotParseResponse:
                        this.error.value = APIError.errorParsing
                    default:
                        this.error.value = APIError.unknown
                    }
                }
            }, receiveValue: { [weak self] value in
                guard let this = self else { return }
                this.drinks.send(value.drinks)
                this.objectWillChange.send()
            })
    }
}

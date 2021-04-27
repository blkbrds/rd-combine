//
//  SwiftUIView.swift
//  NetworkingCombine
//
//  Created by MBA0283F on 4/12/21.
//

import SwiftUI
import Combine

final class DrinksViewModel: ObservableObject {

    // Network
    private let cocktailNetworkManager = CocktailNetworkManager()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var searchText = ""
    @Published var drinks: [Cocktail] = []
    @Published var isLoading: Bool = false
    @Published var error: APIError?
    
    init() {
        typealias DrinkResponseData = CocktailNetworkManager.DrinkResponseData
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .removeDuplicates()
            .print("DrinksViewModel")
            .flatMap({ text -> AnyPublisher<DrinkResponseData, Never> in
                let emptyDataPublisher = Just(DrinkResponseData.init()).eraseToAnyPublisher()
                if text.isEmpty {
                    return emptyDataPublisher
                }
                self.isLoading = true
                return self.cocktailNetworkManager.getCocktails(name: text)
                    .catch({ (error) -> AnyPublisher<DrinkResponseData, Never> in
                        self.error = error as? APIError
                        return emptyDataPublisher
                    })
                    .eraseToAnyPublisher()
            })
            .map({ $0.data ?? [] })
            .sink(receiveValue: { drinks in
                self.isLoading = false
                self.drinks = drinks
            })
            .store(in: &subscriptions)
    }
}

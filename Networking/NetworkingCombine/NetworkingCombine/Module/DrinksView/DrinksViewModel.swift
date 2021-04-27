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
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .removeDuplicates()
            .print("DrinksViewModel")
            .flatMap(maxPublishers: .max(1), { text -> AnyPublisher<CocktailNetworkManager.DrinkResponseData, Never> in
                let emptyDataPublisher = Just(CocktailNetworkManager.DrinkResponseData.init()).eraseToAnyPublisher()
                if text.isEmpty {
                    return emptyDataPublisher
                }
                self.isLoading = true
                let publisher = self.cocktailNetworkManager.getCocktails(name: text)
                    .catch({ (error) -> AnyPublisher<CocktailNetworkManager.DrinkResponseData, Never> in
                        self.error = APIError.unknow(error.localizedDescription)
                        return emptyDataPublisher
                    })
                    .eraseToAnyPublisher()
                
                return publisher
            })
            .sink(receiveValue: { value in
                self.isLoading = false
                self.drinks = value.data ?? []
            })
            .store(in: &subscriptions)
    }
}

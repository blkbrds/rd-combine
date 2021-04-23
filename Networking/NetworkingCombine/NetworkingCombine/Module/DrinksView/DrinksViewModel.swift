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
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .removeDuplicates()
            .sink(receiveCompletion: {
                print("receiveCompletion", $0)
            }, receiveValue: { [weak self] text in
                if !text.isEmpty {
                    self?.searchForDrink(with: text)
                    print("receiveValue", text)
                }
            })
            .store(in: &subscriptions)
    }
    
    func searchForDrink(with text: String) {
        cocktailNetworkManager.getCocktails(name: text)
            .sink { error in
                print(error)
            } receiveValue: { value in
                self.drinks = value.data ?? []
            }.store(in: &subscriptions)
    }
}

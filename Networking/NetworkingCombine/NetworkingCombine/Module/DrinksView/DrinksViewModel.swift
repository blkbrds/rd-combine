//
//  SwiftUIView.swift
//  NetworkingCombine
//
//  Created by MBA0283F on 4/12/21.
//

import SwiftUI
import Combine

final class DrinksViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    private var searchText = PassthroughSubject<String, Never>()
    private var isValid = PassthroughSubject<String, Never>()
    
    @Published var text = "" {
        didSet {
            searchText.send(text)
        }
    }
    @Published var drinks: [Cocktail] = []
    
    init() {
        searchText
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
        
    }
}

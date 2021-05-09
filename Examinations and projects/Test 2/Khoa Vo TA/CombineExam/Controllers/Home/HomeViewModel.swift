//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    
    // MARK: - Properties
    var cocktails = CurrentValueSubject<[Cocktail], Never>([])
    @Published var keyword: String?
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        $keyword
            .dropFirst()
            .sink(receiveValue: { [weak self] keyword in
                guard let this = self else { return }
                this.getCocktails(byName: keyword ?? "")
            }).store(in: &subscriptions)
    }
    
    // MARK: - Public
    func numberOfItems() -> Int {
        return cocktails.value.count
    }

    func getCocktails(byName name: String) {
        guard let keyword = keyword else { return }
        let service: CocktailService = CocktailService()
        service.getCocktails(byName: keyword)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] results in
                guard let this = self else { return }
                this.cocktails.value = results.drinks ?? []
            }).store(in: &subscriptions)
    }
}

//
//  HomeViewModel.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/14/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Combine
import Foundation

final class HomeViewModel {
    var filterPublisher = CurrentValueSubject<[Cocktail],Never>([])
    @Published var searchText: String?
    var subscriptions = Set<AnyCancellable>()
    let cocktailService: CocktailService = CocktailService()

    init() {
        $searchText
            .dropFirst()
            .sink { value in
                self.getDetailsCocktail(searchText: value ?? "")
        }
        .store(in: &subscriptions)
    }

    func getDetailsCocktail(searchText: String) {
        cocktailService.getCocktailByName(searchText: searchText)
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { value in
                self.filterPublisher.value = value.data ?? []
        }.store(in: &subscriptions)
    }
}



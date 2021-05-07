//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Combine
import UIKit

final class HomeViewModel {
    
    private var subscriptions: Set<AnyCancellable> = []
    let error: CurrentValueSubject<Error?, Never> = .init(nil)
    let drinks: CurrentValueSubject<[Drink], Never> = .init([])
    let keyword: CurrentValueSubject<String, Never> = .init("")
    
    init() {
        keyword
            .throttle(for: 1.0, scheduler: DispatchQueue.main, latest: true)
            .erasedFlatMap {
                apiProvider.request(.search($0))
            }
            .tryMap(Drink.self)
            .print("!@#")
            .sink(
                receiveCompletion: { [weak self] in
                    guard let this = self else { return }
                    if case .failure(let error) = $0 {
                        this.error.value = error
                    }
                },
                receiveValue: { [weak self] value in
                    guard let this = self else { return }
                    this.drinks.value = value.drinks
                }
            )
            .store(in: &subscriptions)
    }
}

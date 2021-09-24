//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    var drinks: [Drink] = []
    private var api = APIManagement()
    private var subscriptions = Set<AnyCancellable>()

    func getListDrinks(_ search: String) -> Future<Void, APIError> {
        return Future { [weak self] resolve in
            guard let this = self else { return resolve(.failure(APIError.unknown)) }
            this.api.getListDrink(search)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        resolve(.failure(error))
                    }
                }, receiveValue: { drinks in
                    this.drinks = drinks.drinks
                    resolve(.success(()))
                })
                .store(in: &this.subscriptions)
        }
    }
}

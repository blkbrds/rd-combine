//
//  DetailViewModel.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 8/3/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class DetailViewModel {

    @Published private(set) var apiResult: APIResult<[DrinkDetail]> = .none

    private(set) var idDrink: String
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    init(drink: Drink) {
        idDrink = drink.idDrink
    }

    func getDetailOfDrink() {
        isLoading.send(true)
        APIType.getDetailOfDrink(idDrink: idDrink)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let this = self else { return }
                this.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }
}

//
//  HomeViewModel.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel {

    // MARK: - Properties
    var provinceSubject = CurrentValueSubject<[Province], Never>([])
    var subscriptions = Set<AnyCancellable>()
    var provinceNetWorkManager: ProvinceNetWorkManager = ProvinceNetWorkManager()

    // MARK: - Functions
    func getNameProvince() {
        provinceNetWorkManager.getName()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                self.provinceSubject.value = value.data ?? []
            }).store(in: &subscriptions)
    }
}

//
//  HomeViewModel.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/21/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel: ViewModelType {

    // MARK: - Properties
    // API Result
    @Published private(set) var apiResult: APIResult<[Drink]> = .none
    @Published private(set) var tagGroups: APIResult<[Category]> = .none
    var categoryListSubject = CurrentValueSubject<[Category], Never>([])
    var categoryList: [Category] = []

    // ViewModelType conforming
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    // MARK: - Public functions
    func getDrinkByCategory(key: String, strCategory: String) {
        isLoading.send(true)
        APIType.getDrinkByCategory(key: key, strCategory: strCategory)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let this = self else { return }
                this.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }

    func getCategoryList(key: String) {
        isLoading.send(true)
        APIType.getCategoryList(key: key)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let this = self else { return }
                this.isLoading.send(false)
            })
            .assign(to: \.tagGroups, on: self)
            .store(in: &subscriptions)
    }
}

//
//  ListTypeViewModel.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class ListTypeViewModel: ViewModelType {

    // MARK: - Properties
    // API Result
    @Published private(set) var apiResult: APIResult<TypeList> = .none

    // ViewModelType conforming
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    // MARK: - Public functions
    func performGetListType() {
        isLoading.send(true)
        APIType.getListType()
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                guard let this = self else { return }
                this.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }
}

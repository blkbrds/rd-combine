//
//  ListWorkViewModel.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class ListWorkViewModel: ViewModelType {

    // MARK: - Properties
    // Need init
    private var typeId: String
    private(set) var title: String

    // Private
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private(set) var limit: Int = 0

    // API Result
    @Published private(set) var apiResult: APIResult<WorkList> = .none

    // Publisher
    private(set) var works: CurrentValueSubject<[Work], Never> = .init([])

    // ViewModelType conforming
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialize
    init(type: Type) {
        typeId = type.id
        title = type.label
        $apiResult
            .handle(onSucess: { [weak self] in
                guard let this = self else { return }
                this.works.send(this.works.value + $0.works)
                this.currentPage = $0.query.currentPage
                this.totalPages = $0.totalResults / $0.itemsPerPage
                this.limit = $0.itemsPerPage
            })
            .store(in: &subscriptions)
    }

    // MARK: - Public functions
    func performGetListWork() {
        isLoading.send(true)
        APIType.getListWork(typeId: typeId, currentPage: 0)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                self?.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }

    func performLoadMoreListWork() {
        let page = self.currentPage + 1
        guard !isLoading.value && works.value.isNotEmpty, currentPage <= totalPages else {
            return
        }
        isLoading.send(true)
        APIType.getListWork(typeId: typeId, currentPage: page)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                self?.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }
}

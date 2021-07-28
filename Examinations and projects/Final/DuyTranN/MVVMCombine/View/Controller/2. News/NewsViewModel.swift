//
//  NewsViewModel.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIColor

final class NewsViewModel: ViewModelType {

    // MARK: - Properties
    // API Result
    @Published private(set) var apiResult: APIResult<ArticlesResponse<[Article]>> = .none

    // ViewModelType conforming
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    var searchInputSubject = CurrentValueSubject<String, Never>("")

    // MARK: - Public functions
    func requestGetListArticles() {
        isLoading.send(true)
        APIType.getListArticles()
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                guard let this = self else { return }
                this.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }

    func requestSearchArticles() {
        isLoading.send(true)
        APIType.getSearchArticles(by: searchInputSubject.value)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                guard let this = self else { return }
                this.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }

    func itemBackgroundColor(at indexPath: IndexPath) -> UIColor {
        if indexPath.row % 2 == 0 {
            return Colors.lightBlue
        } else {
            return Colors.lightGreen
        }
    }
}

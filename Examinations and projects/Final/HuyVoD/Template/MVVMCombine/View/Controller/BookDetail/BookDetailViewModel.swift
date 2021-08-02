//
//  BookDetailViewModel.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class BookDetailViewModel: ViewModelType {
    
    // MARK: - Properties


    // API Result
    @Published private(set) var apiResult: APIResult<Book> = .none

    // Publisher
    private(set) var book: CurrentValueSubject<Book?, Never> = .init(nil)

    // ViewModelType conforming
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []
    
    private var id: String

    // MARK: - Initialize
    init(id: String) {
        self.id = id
        $apiResult
            .handle(onSucess: { [weak self] in
                guard let this = self else { return }
                this.book.send($0)

            })
            .store(in: &subscriptions)
    }

   
    func performBookDetail() {
        isLoading.send(true)        
        APIBook.getDetailBook(id: id)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                self?.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }
}

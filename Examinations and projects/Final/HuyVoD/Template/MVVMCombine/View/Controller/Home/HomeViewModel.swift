//
//  HomeViewModel.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel: ViewModelType {
    
    // MARK: - Properties

    // Private
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private(set) var limit: Int = 10

    // API Result
    @Published private(set) var apiResult: APIResult<BookData> = .none
    @Published private(set) var coApiResult: APIResult<BookData> = .none

    // Publisher
    private(set) var books: CurrentValueSubject<[Book], Never> = .init([])
    private(set) var newBooks: CurrentValueSubject<[Book], Never> = .init([])
    var keyWord: CurrentValueSubject<String, Never> = .init("no")
    

    // ViewModelType conforming
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialize
    init() {
        $apiResult
            .handle(onSucess: { [weak self] in
                guard let this = self else { return }
                this.books.send(this.books.value + $0.books)
                this.currentPage = Int($0.currentPage ?? "1") ?? 0
                this.totalPages = Int($0.totalresults) ?? 0 / 10
            })
            .store(in: &subscriptions)
        $coApiResult
            .handle(onSucess: { [weak self] in
                guard let this = self else { return }
                this.newBooks.send(this.newBooks.value + $0.books)
            })
            .store(in: &subscriptions)
        
        Publishers.Zip(books, newBooks)
            .eraseToAnyPublisher()
            .catch { _ in
                Just(([], []))
            }
            .sink(receiveValue: { [weak self] _, _ in
                self?.isLoading.send(false)
            })
            .store(in: &subscriptions)
        keyWord
            .dropFirst()
            .sink { [weak self] (keyword) in
                if keyword.count >= 2 {
                    self?.performListBook(with: keyword)
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - Public functions
    func performGetListBook() {
        isLoading.send(true)
        let pub1 = APIBook.getListBook(with: "no", curentpage: 1)
            .transformToAPIResult()
        
        let pub2 = APIBook.getNewBook()
            .transformToAPIResult()
    
        Publishers.Zip(pub1, pub2).sink { [weak self] (bookResult, newbookResult) in
            self?.apiResult = bookResult
            self?.coApiResult = newbookResult
            self?.isLoading.send(false)
        }.store(in: &subscriptions)
    }
    
    func performListBook(with keyWord: String) {
        isLoading.send(true)
        books.send([])
        APIBook.getListBook(with: keyWord, curentpage: 1)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                self?.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }

    func performLoadMoreListBook() {
        let page = self.currentPage + 1
        guard !isLoading.value && books.value.isNotEmpty, currentPage <= totalPages else {
            return
        }
        isLoading.send(true)
        var keyword: String {
            if keyWord.value.count < 2 {
                return "no"
            }
            return keyWord.value
        }
        APIBook.getListBook(with: keyword, curentpage: page)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { [weak self ] _ in
                self?.isLoading.send(false)
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }
}

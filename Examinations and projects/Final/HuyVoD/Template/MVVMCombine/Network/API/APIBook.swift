//
//  APIBook.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class APIBook {
    static func getListBook(with key: String, curentpage: Int) -> AnyPublisher<BookData, Error> {
        return NetworkingController.shared
            .requestWithTarget(BookService.listBook(key: key, curentPage: curentpage))
            .response(BookData.self)
            .eraseToAnyPublisher()
    }

    static func getNewBook() -> AnyPublisher<BookData, Error> {
        return NetworkingController.shared
            .requestWithTarget(BookService.newBook)
            .response(BookData.self)
            .eraseToAnyPublisher()
    }
    
    static func getDetailBook(id: String) -> AnyPublisher<Book, Error> {
        return NetworkingController.shared
            .requestWithTarget(BookService.detailBook(id: id))
            .response(Book.self)
            .eraseToAnyPublisher()
    }
    
}

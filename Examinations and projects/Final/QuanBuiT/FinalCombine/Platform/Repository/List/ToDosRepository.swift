//
//  ToDosRepository.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain
import Combine

final class ToDosRepository {

    enum CustomError: Error {
        case notFound
    }

    private let repository: RemoteRepository<ToDo>

    init(repository: RemoteRepository<ToDo>) {
        self.repository = repository
    }

    func fetchToDos(urlQueryItem: [URLQueryItem]) -> AnyPublisher<[ToDo], Error> {
        repository.queryPublisher(forQueryItems: urlQueryItem)
    }
    
    func fetch(withId id: String) -> AnyPublisher<ToDo, Error> {
        repository.queryPublisher(forId: id)
    }

    func search(with query: String) -> AnyPublisher<[ToDo], Error> {
        repository.queryPublisher(forQueryItems: [
            URLQueryItem(name: "query", value: query),
            // URLQueryItem(name: "page", value: "\(page)")
        ])
        .flatMap { items -> Result<[ToDo], Error>.Publisher in
            guard !items.isEmpty else {
                return .init(CustomError.notFound)
            }
            return .init(items)
        }.eraseToAnyPublisher()
    }
}

final class ToDoDetailRepository {

    enum CustomError: Error {
        case notFound
    }

    private let repository: RemoteRepository<ToDoDetail>

    init(repository: RemoteRepository<ToDoDetail>) {
        self.repository = repository
    }
    
    func fetch(withId id: String) -> AnyPublisher<ToDoDetail, Error> {
        repository.queryPublisher(forId: id)
    }
}

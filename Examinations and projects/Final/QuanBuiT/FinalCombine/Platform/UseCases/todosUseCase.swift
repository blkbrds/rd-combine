//
//  ToDosUseCase.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain
import Combine

final class ToDosUseCase: Domain.ToDosUseCase {

    private let repository: ToDosRepository

    init(repository: ToDosRepository) {
        self.repository = repository
    }

    func fetchAll() -> AnyPublisher<[ToDo], Error> {
        repository.fetchToDos(urlQueryItem: [URLQueryItem(name: "c", value: "England"), URLQueryItem(name: "s", value: "Soccer")])
    }

    func fetch(with id: String) -> AnyPublisher<ToDo, Error> {
        repository.fetch(withId: id)
    }

    func search(with name: String) -> AnyPublisher<[ToDo], Error> {
        repository.search(with: name)
    }
}

final class ToDoDetailUseCase: Domain.ToDoDetailUseCase {

    private let repository: ToDoDetailRepository

    init(repository: ToDoDetailRepository) {
        self.repository = repository
    }

    func fetch(with id: String) -> AnyPublisher<ToDoDetail, Error> {
        repository.fetch(withId: id)
    }
}

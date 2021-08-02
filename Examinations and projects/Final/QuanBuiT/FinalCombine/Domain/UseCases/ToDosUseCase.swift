//
//  ToDosUseCase.swift
//  Domain
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Combine

public protocol ToDosUseCase {
    func fetchAll() -> AnyPublisher<[ToDo], Error>
    func fetch(with id: String) -> AnyPublisher<ToDo, Error>
    func search(with name: String) -> AnyPublisher<[ToDo], Error>
}

public protocol ToDoDetailUseCase {
    func fetch(with id: String) -> AnyPublisher<ToDoDetail, Error>
}

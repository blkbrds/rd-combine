//
//  RepositoryProvider.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Foundation

final class RepositoryProvider {

    private let baseURL: URL
    private let network: Network

    init(baseURL: URL) {
        self.baseURL = baseURL
        self.network = Network(session: URLSession.shared)
    }

    public func makeToDosRepository() -> ToDosRepository {
        ToDosRepository(
            repository: .init(
                baseURL: baseURL,
                network: network,
                endpoint: Endpoints.todos
            )
        )
    }
    
    public func makeToDoDetailRepository() -> ToDoDetailRepository {
        ToDoDetailRepository(
            repository: .init(
                baseURL: baseURL,
                network: network,
                endpoint: Endpoints.todoDetail
            )
        )
    }
}

//
//  UseCaseProvider.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {

    private let repositoryProvider: RepositoryProvider

    public init(baseURL: URL) {
        self.repositoryProvider = RepositoryProvider(baseURL: baseURL)
    }

    public func makeToDosUseCase() -> Domain.ToDosUseCase {
        ToDosUseCase(
    repository: repositoryProvider.makeToDosRepository()
        )
    }
    
    public func makeToDoDetailUseCase() -> Domain.ToDoDetailUseCase {
        ToDoDetailUseCase(
    repository: repositoryProvider.makeToDoDetailRepository()
        )
    }
}

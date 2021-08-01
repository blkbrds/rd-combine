//
//  ToDoDetailViewModel.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Combine
import Domain
import Platform

class ToDoDetailViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        // Actions
        let loadData: AnyPublisher<Void, Never>
    }
    // MARK: - Output
    struct Output {
        let result: AnyPublisher<Result<ToDoDetail, Error>, Never>
    }
    
    // MARK: - Properties
    private let todoId: String
    private let useCase: Domain.ToDoDetailUseCase
    
    // MARK: - Init
    init(todoId: String) {
        self.todoId = todoId
        self.useCase = Platform.UseCaseProvider(
            baseURL: App.Server.baseURL
        ).makeToDoDetailUseCase()
    }
    
    // MARK: - I/O Transformer
    func transform(_ input: Input) -> Output {
        return Output(
            result: input.loadData
                .flatMap { _ in
                    self.useCase.fetch(with: self.todoId)
                        .map {
                            Result<ToDoDetail,Error>.success($0)
                        }
                        .catch { error -> Just<Result<ToDoDetail, Error>> in
                            return Just(.failure(error))
                        }
                }
                .eraseToAnyPublisher()
        )
    }
}

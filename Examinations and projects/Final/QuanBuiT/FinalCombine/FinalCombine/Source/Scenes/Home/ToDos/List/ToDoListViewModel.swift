//
//  ToDoListViewModel.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Combine
import Domain
import Platform

class ToDoListViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let refresh: AnyPublisher<Void, Never>
        let itemSelected: AnyPublisher<String, Never>
        let loadMore: AnyPublisher<Void, Never>
    }
    // MARK: - Output
    struct Output {
        let results: AnyPublisher<[ToDo], Never>
    }

    // MARK: - Properties
    private let coordinator: AnyCoordinatable<ToDoListCoordinator.Route>?
    private let useCase: Domain.ToDosUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(coordinator: AnyCoordinatable<ToDoListCoordinator.Route>) {
        self.coordinator = coordinator
        self.useCase = Platform.UseCaseProvider(
            baseURL: App.Server.baseURL
        ).makeToDosUseCase()
    }

    // MARK: - I/O Transformer
    func transform(_ input: Input) -> Output {
        // Item selection handeled locally
        input.itemSelected.sink(receiveValue: { [weak self] id in
            self?.coordinator?.coordinate(to: .detail(id: id))
        }).store(in: &cancellables)
        
        return Output(
            results: input.refresh
                .flatMap { _ in
                    self.useCase.fetchAll()
                        .catch { _ -> Just<[ToDo]> in
                            // TODO: Handle Error
                            return Just([])
                        }
                }
                .eraseToAnyPublisher()
        )
    }
}

//
//  SearchViewModel.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Combine
import Domain
import Platform

class SearchViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let refresh: AnyPublisher<Void, Never>
        let itemSelected: AnyPublisher<String, Never>
        let loadMore: AnyPublisher<Void, Never>
        let search: AnyPublisher<String?, Never>
    }
    // MARK: - Output
    struct Output {
        let results: AnyPublisher<[ToDo], Never>
    }

    // MARK: - Properties
    private let coordinator: AnyCoordinatable<SearchCoordinator.Route>?
    private let useCase: Domain.ToDosUseCase
    private var cancellables = Set<AnyCancellable>()
    @Published var searchList: [ToDo] = []
    var todoList: [ToDo] = []
    
    // MARK: - Init
    init(coordinator: AnyCoordinatable<SearchCoordinator.Route>) {
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
        input.search
            .drop(while: { $0 == "" })
            .sink { [weak self] keyword in
            guard let this = self, let keyword = keyword else { return }
                this.searchList = this.todoList.filter { $0.strLeague.lowercased().contains(keyword.lowercased()) }
        }
        .store(in: &cancellables)
        
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

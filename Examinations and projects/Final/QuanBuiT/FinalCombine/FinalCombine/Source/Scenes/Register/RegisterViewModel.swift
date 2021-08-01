//
//  RegisterViewModel.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Foundation
import Combine

final class RegisterViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        // Data
        let username: AnyPublisher<String?, Never>
        let password: AnyPublisher<String?, Never>
        // Actions
        let doRegister: AnyPublisher<Void, Never>
        let doCancel: AnyPublisher<Void, Never>
    }
    // MARK: - Output
    struct Output {
        let enableRegister: AnyPublisher<Bool, Never>
    }

    private var cancellables = Set<AnyCancellable>()
    private let coordinator: AnyCoordinatable<RegisterCoordinator.Route>?
    
    // MARK: - Init
    init(coordinator: AnyCoordinatable<RegisterCoordinator.Route>) {
        self.coordinator = coordinator
    }
    
    // MARK: - I/O Transformer
    func transform(_ input: Input) -> Output {
        input.doRegister
            .sink { [weak self] _ in
                self?.coordinator?.coordinate(to: .register)
            }
            .store(in: &cancellables)
        input.doCancel
            .sink { [weak self] _ in
                self?.coordinator?.coordinate(to: .cancel)
            }
            .store(in: &cancellables)
        return Output(
            enableRegister: Publishers.CombineLatest(input.username, input.password)
                .map { username, password in
                    !(username?.isEmpty ?? false) && password?.count ?? 0 > 7
                }
                .eraseToAnyPublisher())
    }
}

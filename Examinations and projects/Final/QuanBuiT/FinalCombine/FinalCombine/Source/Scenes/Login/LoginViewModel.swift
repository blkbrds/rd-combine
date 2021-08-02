//
//  LoginViewModel.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//
import Foundation
import Combine

class LoginViewModel: ViewModelType {

    // MARK: - Input
    struct Input {
        // Data
        let username: AnyPublisher<String?, Never>
        let password: AnyPublisher<String?, Never>
        // Actions
        let doLogin: AnyPublisher<Void, Never>
        let doRegister: AnyPublisher<Void, Never>
    }
    // MARK: - Output
    struct Output {
        let enableLogin: AnyPublisher<Bool, Never>
    }

    private var cancellables = Set<AnyCancellable>()
    private let coordinator: AnyCoordinatable<LoginCoordinator.Route>?
    
    // MARK: - Init
    init(coordinator: AnyCoordinatable<LoginCoordinator.Route>) {
        self.coordinator = coordinator
    }
    
    // MARK: - I/O Transformer
    func transform(_ input: Input) -> Output {
        input.doLogin
            .sink { [weak self] _ in
                self?.coordinator?.coordinate(to: .signUp)
            }
            .store(in: &cancellables)
        input.doRegister
            .sink { [weak self] _ in
                self?.coordinator?.coordinate(to: .register)
            }
            .store(in: &cancellables)

        return Output(
            enableLogin: Publishers.CombineLatest(input.username, input.password)
                .map { username, password in
                    (username?.isEmailValid() ?? false) && password?.count ?? 0 > 7
                }
                .eraseToAnyPublisher()
        )
    }
}

private extension String {

    private var emailPredicate: NSPredicate {
        let userid = "[A-Z0-9a-z._%+-]{1,}"
        let domain = "([A-Z0-9a-z._%+-]{1,}\\.){1,}"
        let regex = userid + "@" + domain + "[A-Za-z]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex)
    }

    func isEmailValid() -> Bool {
        return emailPredicate.evaluate(with: self)
    }
}

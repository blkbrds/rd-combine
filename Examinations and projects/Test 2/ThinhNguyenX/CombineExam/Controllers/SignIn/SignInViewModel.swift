//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    @Published var userName: String?
    @Published var passWord: String?
    @Published var isLoading = false

    let validationResult = PassthroughSubject<Void, Error>()

    private(set) lazy var isInputValid = Publishers.CombineLatest($userName, $passWord)
        .map { ($0.count > 2 && $0.count < 20) && ($1.count > 8 && $1.count < 20) }
        .eraseToAnyPublisher()

    private let loginValidator: LoginValidatorProtocol

    init(loginValidator: LoginValidatorProtocol = LoginValidator()) {
        self.loginValidator = loginValidator
    }

    func validateLogin() {
        isLoading = true
        loginValidator.validateLogins(userName: userName ?? "", password: passWord ?? "") { [weak self] result in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success:
                this.validationResult.send(())
            case let .failure(error):
                this.validationResult.send(completion: .failure(error))
            }
        }
    }
}

// MARK: - LoginValidatorProtocol
protocol LoginValidatorProtocol {
    func validateLogins(userName: String, password: String, completion: @escaping (Result<(), Error>) -> Void)
}

final class LoginValidator: LoginValidatorProtocol {
    func validateLogins(userName: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
        let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            // hardcoded success
            completion(.success(()))
        }
    }
}

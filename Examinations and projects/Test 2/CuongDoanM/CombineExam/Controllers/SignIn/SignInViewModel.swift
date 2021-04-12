//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Combine

final class SignInViewModel {
    
    private let validator: SignInValidator = SignInValidator()
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var username: String = ""
    @Published var password: String = ""
    let signInAction: PassthroughSubject<Void, Never> = .init()

    let isValid: CurrentValueSubject<Bool, Never> = .init(false)
    let signInDone: PassthroughSubject<Bool, Never> = .init()
    
    lazy var isValidUsername: ValidationPublisher = {
        validator.validateUsername(for: $username)
    }()
    
    lazy var isValidPassword: ValidationPublisher = {
        validator.validatePassword(for: $password)
    }()
    
    init() {
        Publishers.CombineLatest(isValidUsername, isValidPassword)
            .map { isValidUsername, isValidPassword in
                [isValidUsername, isValidPassword].allSatisfy { $0.isSuccess }
            }
            .subscribe(isValid)
            .store(in: &subscriptions)
        signInAction
            .sink { [weak self] in
                guard let this = self else { return }
                let signInDone: Bool = LocalDatabase.users.first(where: { this.checkUser($0) }) != nil
                this.signInDone.send(signInDone)
            }
            .store(in: &subscriptions)
    }
    
    private func checkUser(_ user: User) -> Bool {
        user.name.lowercased() == username.lowercased() && user.password.lowercased() == password.lowercased()
    }
}

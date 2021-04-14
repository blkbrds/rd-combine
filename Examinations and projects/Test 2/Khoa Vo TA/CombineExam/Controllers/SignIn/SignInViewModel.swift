//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    
    enum State {
        case valid
        case failed(SignInError)
        case validateFailed(SignInError)
    }
    
    enum Action {
        case validate
    }
    
    init() {
        signInState.sink { [weak self] signInState in
            guard let this = self else { return }
            this.handleState()
        }.store(in: &subscriptions)

        action
            .sink(receiveValue: { [weak self] action in
                self?.handleAction()
            })
            .store(in: &subscriptions)
    }

    var subscriptions = Set<AnyCancellable>()
    let signInState = PassthroughSubject<State, Never>()
    let signInError: CurrentValueSubject = CurrentValueSubject<SignInError?, Never>(nil)
    let action = PassthroughSubject<Action, Never>()
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    var isLoginValid: AnyPublisher<Bool, Never>?
    
    var checkValidUser: Bool {
        return LocalDatabase.users.contains(where: { $0.name == emailText && $0.password == passwordText })
    }
    
    private func handleState() {
        isLoginValid = Publishers.CombineLatest($emailText, $passwordText)
                            .map { emailText, passwordText -> Bool in
                                return !emailText.isEmpty && !passwordText.isEmpty
                            }
                            .eraseToAnyPublisher()
    }
    
    private func handleAction() {
        if emailText.count < 2 || emailText.count > 20 {
            signInState.send(.validateFailed(.invalidUsernameLength))
        } else if emailText.containsEmoji {
            signInState.send(.validateFailed(.invalidUsername))
        } else if passwordText.count < 8 || passwordText.count > 20 {
            signInState.send(.validateFailed(.invalidPasswordLength))
        } else if !checkValidUser {
            signInState.send(.failed(.notMatch))
        } else {
            signInState.send(.valid)
        }
    }
}

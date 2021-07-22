//
//  RegisterViewModel.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import Foundation
import Combine

enum LoginError {
    case accountName
    case username
    case password
    case confirmedPassword

    var message: String {
        switch self {
        case .accountName:
            return "App.Texts.incorrectAccountName"
        case .username:
            return "Username is error"
        case .password:
            return "Password is error"
        case .confirmedPassword:
            return "Confirm password is not same password"
        }
    }
}

final class RegisterViewModel {
    enum ScreenType {
        case login
        case register
    }

    enum State {
        case initial(ScreenType)
        case registered
        case failed(Error)
        case validateFailed(LoginError)
    }

    enum Action {
        case login
        case register
        case validate
//        case getUserStatus
    }

    // MARK: - Properties
    var screenType: ScreenType = .login

    let action = PassthroughSubject<Action, Never>()
    let state = CurrentValueSubject<State, Never>(.initial(.login))

    @Published var username: String?
    @Published var password: String?

    var subscriptions = Set<AnyCancellable>()
    var isInfoValid: AnyPublisher<Bool, Never>?
    var isLoading = CurrentValueSubject<Bool, Never>(false)

    init(screenType: ScreenType) {
        state.send(.initial(screenType))
        state
            .sink { [weak self] state in
                self?.processState(state)
            }
            .store(in: &subscriptions)
        action
            .sink(receiveValue: { [weak self] action in
                self?.processAction(action)
            })
            .store(in: &subscriptions)
    }

    private func processState(_ state: State) {
        switch state {
        case .initial(let screenType):
            self.screenType = screenType
            switch screenType {
            case .login:
                isInfoValid = Publishers.CombineLatest($username, $password)
                    .map { emailText, passwordText -> Bool in
                        guard let emailText = emailText, let passwordText = passwordText else { return false }
                        return !emailText.isEmpty && !passwordText.isEmpty
                    }
                    .eraseToAnyPublisher()
            case .register:
                isInfoValid = Publishers.CombineLatest($username, $password)
                    .map { usernameText, passwordText in
                        guard let usernameText = usernameText,
                              let passwordText = passwordText else { return false }
                        return !usernameText.isEmpty && !passwordText.isEmpty
                    }
                    .eraseToAnyPublisher()
            }
        case .registered:
            isLoading.send(false)
        case .failed:
            isLoading.send(false)
        case .validateFailed: break
        }
    }

    private func processAction(_ action: Action) {
        switch action {
        case .login:
            guard let username = username, let password = password else { return }
            login(username: username, password: password)
        case .register:
            guard let username = username, let password = password else { return }
            register(username: username, password: password)
        case .validate:
            switch screenType {
            case .login:
                guard let username = username, let password = password else { return }
                if !username.isUsernameInput() {
                    print("User name error")
                    state.send(.validateFailed(.username))
                } else if !password.isPasswordRegEx() {
                    print("Pass word error")
                    state.send(.validateFailed(.password))
                } else {
                    self.action.send(.login)
                }
            case .register:
                guard let username = username, let password = password else { return }
                if !username.isUsernameInput() {
                    state.send(.validateFailed(.username))
                    print("User name error")
                } else if !password.isPasswordRegEx() {
                    print("Pass word error")
                    state.send(.validateFailed(.password))
                } else {
                    self.action.send(.register)
                }
            }
        }
    }

    private func login(username: String, password: String) {
        if let _ = ud[.userRegistered]?.first(where: { $0.username == username && $0.password == password }) {
            print("Login success")
        } else {
            print("User name of password error")
        }
    }

    private func register(username: String, password: String) {
        ud[.userRegistered]?.append(User(username: username, password: password))
        print("Register success")
    }
}

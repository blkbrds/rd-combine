//
//  RegisterViewModel.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import Foundation
import Combine

enum LoginError {
    case username
    case usernameIncorrect
    case password
    case passwordIncorrect
    case usernameAlreadyExists

    var message: String {
        switch self {
        case .username:
            return "Username is error"
        case .usernameIncorrect:
            return "Username is incorrect"
        case .password:
            return "Password is error"
        case .passwordIncorrect:
            return "Password is incorrect"
        case .usernameAlreadyExists:
            return "Username already exists"
        }
    }
}

final class RegisterViewModel: ViewModel {
    enum ScreenType {
        case login
        case register
    }

    enum State {
        case initial(ScreenType)
        case registered
        case failed(Error)
        case validateFailed(LoginError)
        case loginSuccess
        case registerSuccess
    }

    enum Action {
        case login
        case register
        case validate
    }

    // MARK: - Properties
    var screenType: ScreenType = .login

    let action = PassthroughSubject<Action, Never>()
    let state = CurrentValueSubject<State, Never>(.initial(.login))

    @Published var username: String?
    @Published var password: String?

    var isInfoValid: AnyPublisher<Bool, Never>?
    var isLoading = CurrentValueSubject<Bool, Never>(false)

    init(screenType: ScreenType) {
        super.init()
        ud[.userRegistered]?.forEach({ user in
            print("❤️❤️❤️", ud[.userRegistered]?.count ?? 0, user.username ?? "", user.password ?? "")
        })
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
        default: break
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
                    state.send(.validateFailed(.username))
                } else if !password.isPasswordRegEx() {
                    state.send(.validateFailed(.password))
                } else {
                    self.action.send(.login)
                }
            case .register:
                guard let username = username, let password = password else { return }
                if !username.isUsernameInput() {
                    state.send(.validateFailed(.username))
                } else if !password.isPasswordRegEx() {
                    state.send(.validateFailed(.password))
                } else {
                    self.action.send(.register)
                }
            }
        }
    }

    private func login(username: String, password: String) {
        if let account = ud[.userRegistered]?.first(where: { $0.username == username }) {
            if account.password == password {
                state.send(.loginSuccess)
            } else {
                state.send(.validateFailed(.passwordIncorrect))
            }
        } else {
            state.send(.validateFailed(.usernameIncorrect))
        }
    }

    private func register(username: String, password: String) {
        if let _ = ud[.userRegistered]?.first(where: { $0.username == username }) {
            state.send(.validateFailed(.usernameAlreadyExists))
        } else {
            ud[.userRegistered]?.append(User(username: username, password: password))
            state.send(.registerSuccess)
        }
    }
}

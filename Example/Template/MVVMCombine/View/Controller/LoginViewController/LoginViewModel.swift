//
//  LoginViewModel.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/28/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

struct User {
    var username: String
    var password: String
}

final class LoginViewModel {

    enum State {
        case initial
        case logined
        case error(message: String)
    }

    enum Action {
        case login
        case clear
    }

    // MARK: - Properties
    // publisher and store
    @Published var username: String?
    @Published var password: String?
    @Published var isLoading: Bool = false

    // trigger
    var validatedText: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($username, $password)
            .map { usernameTest, passwordText -> Bool in
            guard let usernameText = usernameTest, let passwordText = passwordText else { return false }
            return !(usernameText.isEmpty || passwordText.isEmpty)
        }
            .eraseToAnyPublisher()
    }

    //  model
    var user: User?

    // action, state
    let action = PassthroughSubject<Action, Never>()
    let state = CurrentValueSubject<State, Never>(.initial)
    var subcriptions = Set<AnyCancellable>()

    init(username: String, password: String) {
        self.username = username
        self.password = password

        action
            .sink { [weak self] action in
            self?.processAction(action)
        }
            .store(in: &subcriptions)

        state
            .sink { [weak self] state in
            self?.processState(state)
        }

        self.user = User(username: username, password: password)
    }

    private func processState(_ state: State) {
        switch state {
        case .error(let mess):
            print(mess)
        case .initial:

            if let user = user {
                username = user.username
                password = user.password
                isLoading = false
            } else {
                username = ""
                password = ""
                isLoading = false
            }
        case .logined:
            isLoading = true
        }
    }

    private func processAction(_ action: Action) {
        switch action {
        case .clear:
            clear()
        case .login:
            login()
                .sink { done in
                self.isLoading = false

                if done {
                    self.state.value = .logined
                } else {
                    self.state.value = .error(message: "Loi cmnr")
                }
            }
                .store(in: &subcriptions)
        }
    }

    // wwithout callback
    func clear() {
        username = ""
        password = ""
    }

    func login() -> AnyPublisher<Bool, Never> {
        if isLoading {
            return $isLoading.map { !$0 }.eraseToAnyPublisher()
        }

        isLoading = true

        // test
        let test = username == "thientam123" && password == "thientam123"

        let subject = CurrentValueSubject<Bool, Never>(test)
        return subject.delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }
}

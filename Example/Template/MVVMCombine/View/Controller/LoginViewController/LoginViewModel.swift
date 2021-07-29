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

final class LoginViewModel: ViewModelType {

    enum State {
        case initial
        case logined
        case error (message: String)
    }

    enum Action {
        case gotoTeamVC
    }

    // MARK: - Properties
    var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var subscriptions: Set<AnyCancellable> = []

    @Published var username: String?
    @Published var password: String?
    let isEnabled = CurrentValueSubject<Bool, Never>(false)
    let errorText = CurrentValueSubject<String?, Never>(nil)
    let state = CurrentValueSubject<State, Never>(.initial)
    let action = PassthroughSubject<Action, Never>()
    
    // Model
    var user: User
    //validate
    var isInfoValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($username, $password)
            .map { !($0!.isEmpty || $1!.isEmpty) }
            .eraseToAnyPublisher()
    }

    // MARK: - Initial
    init(username: String, password: String) {
        self.username = username
        self.password = password
        
        self.user = User(username: username, password: password)
        state
            .sink { [weak self] state in
            self?.processState(state)
        }
            .store(in: &subscriptions)

        action
            .sink { [weak self] action in
            self?.processAction(action)
        }
            .store(in: &subscriptions)
    }
    // MARK: - Methods
    private func processState(_ state: State) {
        switch state {
        case .initial:
            errorText.value = nil
        case .error(let message):
            errorText.value = message
        case .logined:
            isLoading.send(true)
        }
    }

    private func processAction(_ action: Action) {
        switch action {
        case .gotoTeamVC:
            
            _ = login().sink { done in
                self.isLoading.send(false)
                
                if done {
                    self.state.value = .logined
                } else {
                    self.state.value = .error(message: "Fail cmnr")
                }
            }
        }
    }
    
//    with callback
    func login() -> AnyPublisher<Bool, Never> {
        isLoading.send(true)
        
        // text
        let test = username == "thientam123" && password == "thientam123"
        
        let subject = CurrentValueSubject<Bool, Never>(test)
        return subject.delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }
}

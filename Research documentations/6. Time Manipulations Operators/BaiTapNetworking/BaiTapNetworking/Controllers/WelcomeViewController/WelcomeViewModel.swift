//
//  WelcomeViewModel.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/19/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation
import Combine

final class WelcomeViewModel {

    // MARK: - Properties
    let name = CurrentValueSubject<String?, Never>(nil)
    let about = CurrentValueSubject<String?, Never>(nil)
    let loginEnabled = CurrentValueSubject<Bool?, Never>(false)
    let errorText = CurrentValueSubject<String?, Never>(nil)
    let state = CurrentValueSubject<State, Never>(.initial)
    var user: User
    var subscriptions = Set<AnyCancellable>()

    enum State {
        case initial
        case error(message: String)
    }

    enum Action {
        case gotoLogin
        case gotoHome
    }

    let action = PassthroughSubject<Action, Never>()

    // MARK: - init
    init(user: User) {
        self.user = user

        // subscripstions
        _ = state.sink(receiveValue: { [weak self] state in
            self?.processState(state)
        }).store(in: &subscriptions)
        _ = action.sink(receiveValue: { [weak self] action in
            self?.processAction(action)
        }).store(in: &subscriptions)
    }

    deinit {
      subscriptions.removeAll()
    }

    // MARK: - Private func
    private func processState(_ state: State) {
        switch state {
        case .initial:
            name.value = user.name
            about.value = user.about
            loginEnabled.value = user.isLogin
            errorText.value = nil
        case .error(let message):
            errorText.value = message
        }
    }

    private func processAction(_ action: Action) {
        switch action {
        case .gotoHome:
            print("goto HomeVC")
        case .gotoLogin:
            print("goto LoginVC")
        }
    }
}

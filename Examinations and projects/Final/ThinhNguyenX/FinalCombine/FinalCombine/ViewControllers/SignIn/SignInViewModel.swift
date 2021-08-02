//
//  SignInViewModel.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import Foundation
import Combine

final class SignInViewModel {

    // MARK: - Enums
    enum ValidateField {
        case userName(String)
        case password(String)
    }

    enum Action {
      case login
      case clear
    }

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false

    private(set) lazy var isInputValid = Publishers.CombineLatest($username, $password)
        .change()
        .map({ output -> ValidateField in
            if output.old?.0 != output.new.0 {
                return .userName(output.new.0)
            } else {
                return .password(output.new.1)
            }
        })
        .map({ valid -> SignInError? in
            switch valid {
            case .userName(let text):
                if text.count < 2 || text.count > 20 {
                    return .invalidUsernameLength
                } else if text.containsEmoji {
                    return .invalidUsername
                }
            case .password(let text):
                if (text.count < 8 || text.count > 20) && !text.isEmpty {
                    return .invalidPasswordLength
                }
            }
            return nil
        })
        .eraseToAnyPublisher()

    var users: [User] = []
    var stores: Set<AnyCancellable> = []

    init() {
        users = DumyData.users
    }

    // MARK: - Actions
    func clear() {
        username = ""
        password = ""
    }

    // MARK: - Private functions
    func signIn(completion: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            completion()
        }
    }
}

extension Publisher {
    func change() -> Publishers.Map<Publishers.Scan<Self, (Optional<Self.Output>, Optional<Self.Output>)>, Change<Self.Output>> {
        return self
            .scan((Output?.none, Output?.none)) { (state, new) in
                (state.1, .some(new))
            }
            .map { (old, new) in
                Change(old: old, new: new!)
            }
    }
}

struct Change<Value> {
    var old: Value?
    var new: Value
}

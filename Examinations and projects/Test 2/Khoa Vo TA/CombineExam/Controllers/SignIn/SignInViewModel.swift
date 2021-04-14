//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    
    enum ValidationState {
        case failed(SignInError)
    }
    
    // MARK: - Properties
    var subscriptions = Set<AnyCancellable>()
    let validationState = PassthroughSubject<ValidationState, Never>()
    let signInError: CurrentValueSubject = CurrentValueSubject<SignInError?, Never>(nil)
    
    @Published var emailText: String?
    @Published var passwordText: String?

    var isValidate: AnyPublisher<Bool, Never>?
    var isUserExistDB: Bool {
        return LocalDatabase.users.contains(where: { $0.name == emailText && $0.password == passwordText })
    }
    
    init() {
        isValidate = Publishers.CombineLatest($emailText, $passwordText)
                            .map { emailText, passwordText -> Bool in
                                guard let emailText = emailText, let passwordText = passwordText else { return false }
                                let isValidEmail: Bool = emailText.count >= 2 && emailText.count <= 20 && !emailText.containsEmoji
                                let isValidPassword: Bool = passwordText.count >= 8 && passwordText.count <= 20
                                return isValidEmail && isValidPassword
                            }
                    .eraseToAnyPublisher()
    }
    
    // MARK: - Public
    func validateEmail() {
        guard let emailText = emailText else { return }
        if emailText.count < 2 || emailText.count > 20 {
            validationState.send(.failed(.invalidUsernameLength))
        } else if emailText.containsEmoji {
            validationState.send(.failed(.invalidUsername))
        }
    }
    
    func validatePassword() {
        guard let passwordText = passwordText else { return }
        if passwordText.count < 8 || passwordText.count > 20 {
            validationState.send(.failed(.invalidPasswordLength))
        }
    }
}

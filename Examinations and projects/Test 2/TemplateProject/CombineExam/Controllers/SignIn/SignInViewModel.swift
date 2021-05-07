//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine


final class SignInViewModel {
    let checkData = PassthroughSubject<Bool, Never>()
    let userName = CurrentValueSubject<String, Never>("")
    let passWord = CurrentValueSubject<String, Never>("12345678")
    let validLogin = PassthroughSubject<(SignInError?, SignInError?), Never>()
    private var subscriptions = Set<AnyCancellable>()

    init() {
        userName
            .sink { [weak self] _ in
                guard let this = self else { return }
                this.validLogin.send((this.validationUserName(), this.validationPassword()))
            }
            .store(in: &subscriptions)

        passWord
            .sink { [weak self] _ in
                guard let this = self else { return }
                this.validLogin.send((this.validationUserName(), this.validationPassword()))
            }
            .store(in: &subscriptions)
    }

    // MARK: - Public functions
    func checkUserName() {
        let account = LocalDatabase.users.first(where: { $0.name == userName.value })
        checkData.send(account != nil)
    }

    // MARK: - Private functions
    private func validationUserName() -> SignInError? {
        let value = userName.value
        guard value.count > 1 && value.count <= 20 else {
            return .invalidUsernameLength
        }

        guard !value.containsEmoji else {
            return .invalidUsername
        }

        return nil
    }

    private func validationPassword() -> SignInError? {
        let value = passWord.value
        guard value.count > 7 && value.count <= 20 else {
            return .invalidPasswordLength
        }
        return nil
    }
}

//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    // MARK: - Properties
    let userNameSubject = CurrentValueSubject<String, Never>("")
    let passwordSubject = CurrentValueSubject<String, Never>("")
    let validationSubject = CurrentValueSubject<(SignInError?, SignInError?), Never>((nil, nil))
    let checkDatabaseSubject = PassthroughSubject<Bool, Never>()

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    init() {
        userNameSubject
            .sink(receiveCompletion: { completion in
                print("Received completion: \(completion)")
            }, receiveValue: { [weak self] _ in
                guard let this = self else { return }
                this.validationSubject.send((this.validationUserName(), this.validationPassword()))
            })
            .store(in: &subscriptions)

        passwordSubject
            .sink(receiveCompletion: { completion in
                print("Received completion: \(completion)")
            }, receiveValue: { [weak self] _ in
                guard let this = self else { return }
                this.validationSubject.send((this.validationUserName(), this.validationPassword()))
            })
            .store(in: &subscriptions)
    }

    // MARK: - Public functions
    func tappedSignInButton() {
        let foundedUser = LocalDatabase.users.first(where: { $0.name == userNameSubject.value })
        checkDatabaseSubject.send(foundedUser != nil)
    }

    // MARK: - Private functions
    private func validationUserName() -> SignInError? {
        let value = userNameSubject.value
        guard value.count > 1 && value.count <= 20 else {
            return .invalidUsernameLength
        }

        guard !value.containsEmoji else {
            return .invalidUsername
        }

        return nil
    }

    private func validationPassword() -> SignInError? {
        let value = passwordSubject.value
        guard value.count > 7 && value.count <= 20 else {
            return .invalidPasswordLength
        }

        return nil
    }
}

//
//  RegisterViewModel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import Foundation
import Combine
import Alamofire
import ObjectMapper
import Firebase

final class RegisterViewModel: ViewModelType {

    // MARK: - Properties
    var publisher = PassthroughSubject<(String, String), Never>()
    var isEmailValid: PassthroughSubject<Bool, Never> = .init()
    var isRegisterSuccess: PassthroughSubject<Bool, Never> = .init()

    // ViewModelType
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    // APIResult
    @Published private(set) var emailApiResult: APIResult<Bool> = .none
    @Published private(set) var registerApiResult: APIResult<Bool> = .none

    // MARK: - Publics
    init() {}

    init(publisher: PassthroughSubject<(String, String), Never>) {
        self.publisher = publisher
        $emailApiResult
            .handle(onSucess: { [weak self] isSuccess in
                guard let this = self else { return }
                this.isEmailValid.send(isSuccess)
            })
            .store(in: &subscriptions)

        $registerApiResult
            .handle(onSucess: { [weak self] isSuccess in
                guard let this = self else { return }
                this.isRegisterSuccess.send(isSuccess)
            })
            .store(in: &subscriptions)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }

    func isCorrectPassword(password: String, rePassword: String) -> Bool {
        return password == rePassword
    }
}

// MARK: - APIs
extension RegisterViewModel {

    private func checkEmailNotExistingFirebase(email: String) -> AnyPublisher<Bool, Error> {
        let publiher = PassthroughSubject<Bool, Error>()
        UserService
            .getAccountWith(email: email)
            .observe(.value, with: { (snapshot) in
            if snapshot.childrenCount == 0 {
                publiher.send(true)
            } else {
                publiher.send(false)
            }
            publiher.send(completion: .finished)
        })
        { error in
            publiher.send(completion: .failure(error))
        }

        return publiher.eraseToAnyPublisher()
    }

    private func registerFirebase(email: String, password: String) -> AnyPublisher<Bool, Error> {
        let publiher = PassthroughSubject<Bool, Error>()
        let id = NSUUID().uuidString
        let params = ["id": id,
            "email": email,
            "password": password] as [String: Any]
        let addEvent: DataEventType = .childAdded
        UserService.register(params: params, id: id).observe(addEvent) { _ in
            publiher.send(true)
            publiher.send(completion: .finished)
        }
        return publiher.eraseToAnyPublisher()
    }

    func checkEmailNotExisting(email: String) {
        hud.show()
        checkEmailNotExistingFirebase(email: email)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.emailApiResult, on: self)
            .store(in: &subscriptions)
    }

    func register(email: String, password: String) {
        hud.show()
        registerFirebase(email: email, password: password)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.registerApiResult, on: self)
            .store(in: &subscriptions)
    }
}

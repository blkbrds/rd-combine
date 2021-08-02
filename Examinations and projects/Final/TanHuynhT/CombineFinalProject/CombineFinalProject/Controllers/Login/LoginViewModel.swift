//
//  LoginViewModel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import Foundation
import Combine
import Alamofire
import ObjectMapper
import Firebase

final class LoginViewModel: ViewModelType {

    // MARK: - Properties
    var isLoginSuccess: PassthroughSubject<Bool, Never> = .init()

    // ViewModelType
    private(set) var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var subscriptions: Set<AnyCancellable> = []

    // APIResult
    @Published private(set) var apiResult: APIResult<Bool> = .none

    // MARK: - Publics
    init() {
        $apiResult
            .handle(onSucess: { [weak self] isSuccess in
                guard let this = self else { return }
                this.isLoginSuccess.send(isSuccess)
            })
            .store(in: &subscriptions)
    }

    func viewModelForRegister(publisher: PassthroughSubject<(String, String), Never>) -> RegisterViewModel {
        return RegisterViewModel(publisher: publisher)
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
}

// MARK: - APIs
extension LoginViewModel {

    private func loginWithFirebase(email: String, password: String) -> AnyPublisher<Bool, Error> {
        let publiher = PassthroughSubject<Bool, Error>()
        UserService
            .getAccountWith(email: email)
            .observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let users = Mapper<User>().mapArray(JSONArray: items)
                if let user = users.first, user.password == password {
                    publiher.send(true)
                } else {
                    publiher.send(false)
                }
                publiher.send(completion: .finished)
            })

        return publiher.eraseToAnyPublisher()
    }

    func login(email: String, password: String) {
        hud.show()
        loginWithFirebase(email: email, password: password)
            .transformToAPIResult()
            .handleEvents(receiveOutput: { _ in
                hud.dismiss()
            })
            .assign(to: \.apiResult, on: self)
            .store(in: &subscriptions)
    }
}

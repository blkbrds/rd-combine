//
//  LoginViewModel.swift
//  Foody
//
//  Created by MBA0283F on 3/18/21.
//

import SwiftUI
import Combine
import Moya

final class LoginViewModel: ViewModel, ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLogged: Bool = false
        
    override init() {
        super.init()
        Session.shared.isShowedOnboarding = true
        email = Session.shared.currentEmail
    }
    
    func login(completion: (() -> Void)? = nil) {
        guard !invalidInfo, !isLoading else {
            return
        }
        isLoading = true
        AccountService.login(email: email, password: password)
            .sink { (completion) in
                if case .failure(let error) = completion {
                    self.error = error
                }
                self.isLoading = false
            } receiveValue: { (response) in
                Session.shared.user = response.user
                Session.shared.accessToken = response.accessToken
                Session.shared.currentEmail = response.user?.email ?? ""
                self.isLogged = response.user != nil && response.accessToken != nil
            }
            .store(in: &subscriptions)
    }
}

extension LoginViewModel {
    
    var invalidInfo: Bool {
        !(email.isValidateEmail && password.isValidPasswordLength)
    }
}

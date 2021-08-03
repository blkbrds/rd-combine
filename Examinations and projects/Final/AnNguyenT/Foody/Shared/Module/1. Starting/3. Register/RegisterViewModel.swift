//
//  RegisterViewModel.swift
//  Foody
//
//  Created by MBA0283F on 3/15/21.
//

import SwiftUI
import SwifterSwift
import Combine
import PhoneNumberKit

final class RegisterUserObject: ObservableObject {
    var type: UserType = .customer
    var gender: Bool = true
    @Published var username: String = ""
    @Published var description: String = ""
    @Published var restaurantName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var verifyPassword: String = ""
    @Published var phoneNumber: String = ""
    @Published var address: String = ""
}

final class RegisterViewModel: ViewModel, ObservableObject {
    @Published var userInfo = RegisterUserObject()
    @Published var emailExist: Bool = false
    @Published var isRestaurant: Bool = false {
        didSet {
            userInfo.type = isRestaurant ? .restaurant: .customer
        }
    }
    @Published var isMale: Bool = true {
        didSet {
            userInfo.gender = isMale
        }
    }
    
    func checkEmail() {
        guard !isLoading else { return }
        isLoading = true
        AccountService.verifyEmail(email: userInfo.email, action: .register)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                self.emailExist = res.isValid ?? false
            }
            .store(in: &subscriptions)
    }
}

extension RegisterViewModel {
    
    var verifyPhoneViewModel: VerifyPhoneViewModel {
        VerifyPhoneViewModel(for: .register, with: userInfo)
    }
    
    var inValidInfo: Bool {
        userInfo.username.trimmed.isEmpty
            || (userInfo.restaurantName.trimmed.isEmpty && userInfo.type.isRestaurant)
            || !userInfo.email.trimmed.isValidateEmail
            || !userInfo.phoneNumber.validatePhoneNumber
            || userInfo.password.trimmed != userInfo.verifyPassword.trimmed
            || !userInfo.password.trimmed.isValidPasswordLength
            || !userInfo.verifyPassword.trimmed.isValidPasswordLength
    }
}

//
//  ForgotPasswordViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 4/5/21.
//

import SwiftUI

final class ForgotPasswordViewModel: ViewModel, ObservableObject {
    @Published var email: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var emailExist: Bool = false
    var phoneNumber: String = ""
    
    var invalidInfo: Bool {
        !(email.trimmed.isValidateEmail && newPassword.trimmed.isValidPasswordLength
            && confirmPassword.trimmed.isValidPasswordLength && newPassword == confirmPassword)
    }
    
    var verifyPhoneViewModel: VerifyPhoneViewModel {
        let userInfo = RegisterUserObject()
        userInfo.phoneNumber = phoneNumber
        userInfo.email = email
        userInfo.password = newPassword
        
        return VerifyPhoneViewModel(for: .updatePassword, with: userInfo)
    }
    
    func handleCheckEmail() {
        guard !isLoading else { return }
        isLoading = true
        AccountService.verifyEmail(email: email, action: .forgot)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                if let phoneNumber = res.phoneNumber {
                    if phoneNumber.validatePhoneNumber {
                        self.phoneNumber = phoneNumber
                        self.emailExist = res.isValid ?? false
                    } else {
                        self.error = .unknown("Phone number is invalid.")
                    }
                }
            }
            .store(in: &subscriptions)
    }
}

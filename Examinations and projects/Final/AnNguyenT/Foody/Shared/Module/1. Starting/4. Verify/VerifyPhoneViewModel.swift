//
//  VerifyPhoneViewModel.swift
//  Foody
//
//  Created by MBA0283F on 3/15/21.
//

import SwiftUI

final class VerifyPhoneViewModel: ViewModel, ObservableObject {
    private var verificationID: String = ""
    
    var userInfo: RegisterUserObject
    var action: Action
    var otpCount: Int = 0
    
    @Published var showSuccessPopup: Bool = false
    @Published var code: String = "" {
        didSet {
            if /*Int(code) == nil || */ code.count > lengthLimit {
                code = oldValue
            }
            // Dismiss keyboard
            if code.count == lengthLimit {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    init(for action: Action = .updatePassword, with userInfo: RegisterUserObject = RegisterUserObject()) {
        self.userInfo = userInfo
        self.action = action
        super.init()
        handleSendOTP()
    }
    
    func codeNumberOf(index: Int) -> String {
        values[safeIndex: index] ?? codeTextEmpty
    }
}

extension VerifyPhoneViewModel {
    private func handleUpdatePassword() {
        // MARK: TODO - handleUpdatePassword
        guard !isLoading else { return }
        isLoading = true
        AccountService.updatePassword(for: userInfo.email, newPassword: userInfo.password)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (response) in
                if let email = response.email {
                    self.showSuccessPopup = true
                    Session.shared.currentEmail = email
                }
            }
            .store(in: &subscriptions)
    }
    
    private func handleRegister() {
        // MARK: TODO - handleRegister
        var user: User = User()
        user.gender = userInfo.gender
        user.username = userInfo.username
        user.email = userInfo.email
        user.phoneNumber = userInfo.phoneNumber
        user.address = userInfo.address
        user.type = UserType.restaurant.rawValue
//        userInfo.imageProfile = ""
        
        
        var restaurant: Restaurant?
        if userInfo.type == .restaurant {
            restaurant = Restaurant()
            restaurant?._id = user._id
            restaurant?.descriptions = userInfo.description
            restaurant?.name = userInfo.restaurantName
            restaurant?.address = userInfo.address
        }
        
        var account: Account = Account()
        account._id = user._id
        account.email = userInfo.email
        account.password = userInfo.password
        account.phoneNumber = userInfo.phoneNumber
        
        guard !isLoading else { return }
        isLoading = true
        AccountService.register(for: user, with: account, restaurant: restaurant)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (response) in
                if let email = response.email, let _ = response.password {
                    self.showSuccessPopup =  true
                    Session.shared.currentEmail = email
                }
            }
            .store(in: &subscriptions)
    }
    
    func handleSendOTP() {
        guard otpCount < 5 else {
            error = CommonError.unknown("OTP code confirmations exceeded!")
            return
        }
        FirebaseTask.verifyPhoneNumber(phoneNumber: phoneNumber)
            .sink { (completion) in
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (verificationID) in
                self.otpCount += 1
                self.verificationID = verificationID
            }
            .store(in: &subscriptions)
    }
    
    func handleVerifyOTP() {
        isLoading = true
        FirebaseTask.signInAuth(verificationID: verificationID, code: code)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                } else {
                    self.handleAction()
                }
            } receiveValue: { (result) in
                print("DEBUG - VerifyPhoneViewModel: ", result)
            }
            .store(in: &subscriptions)

            
    }
    
    func handleAction() {
        if case .register = action {
            handleRegister()
        } else {
            handleUpdatePassword()
        }
    }
}

extension VerifyPhoneViewModel {
    enum Action {
        case register, updatePassword
    }
    
    var lengthLimit: Int { 6 }
    
    var values: [String] {
        Array(code)
            .map({ String($0) })
    }
    
    var isValid: Bool {
        code.count >= lengthLimit
    }
    
    var codeTextEmpty: String {
        "∙"
    }
    
    var phoneNumber: String {
        return userInfo.phoneNumber
    }
    
    var messageNoti: String {
        if case .register = action {
            return "Congratulations your account has been successfully created."
        }
        return "Password reset successful."
    }
    
    var title: String {
        "Continue"
    }
}




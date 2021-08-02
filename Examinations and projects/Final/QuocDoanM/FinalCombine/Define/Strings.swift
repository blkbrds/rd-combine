//
//  Strings.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/13/21.
//

import Foundation

typealias Strings = App.Strings

extension App {
    struct Strings {}
}

extension App.Strings {
    struct Login {}
}

extension Strings.Login {
    static let login = "Login"
    static let register = "Register"
    static let createAccount = "Create Account"
    static let userName = "User Name"
    static let password = "Password"
    static let confirmPassword = "Confirm Password"
    static let noHaveAccount = "Don't have an account?"
    static let forgotPassword = "Forgot Password?"
    static let haveAccount = "Already have an account?"
    static let userNamePlaceholder = "Input User Name"
    static let passwordPlaceholder = "Input Password"
    static let confirmPasswordPlaceholder = "Confirm Password here"
    static let invalidUserNameLength = "Username chỉ được chứa từ 2 đến 20 ký tự"
    static let invalidUsername = "Username không được phép chứa emoji"
    static let invalidPasswordLength = "Password chỉ được chứa từ 8 đến 20 ký tự"
}

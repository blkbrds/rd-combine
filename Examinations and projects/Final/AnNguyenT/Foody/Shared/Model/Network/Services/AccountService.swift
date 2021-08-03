//
//  LoginService.swift
//  Foody
//
//  Created by An Nguyễn on 21/04/2021.
//

import Combine
import Foundation
import FirebaseAuth

protocol AccountFetchable {
    static func login(email: String, password: String) -> AnyPublisher<AccountService.LoginResponse, CommonError>
    static func register(for user: User, with account: Account, restaurant: Restaurant?) -> AnyPublisher<AccountService.AccountResponse, CommonError>
    static func verifyEmail(email: String, action: VerifyAction) -> AnyPublisher<AccountService.AccountResponse, CommonError>
    static func updatePassword(for email: String, newPassword: String) -> AnyPublisher<AccountService.AccountResponse, CommonError>
}

final class AccountService: AccountFetchable {
    struct AccountResponse: Decodable {
        var email: String?
        var password: String?
        var phoneNumber: String?
        var isValid: Bool?
    }
    
    static func updatePassword(for email: String, newPassword: String) -> AnyPublisher<AccountResponse, CommonError> {
        NetworkProvider.shared.request(.updatePassword(email, newPassword))
            .decode(type: AccountResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func verifyEmail(email: String, action: VerifyAction) -> AnyPublisher<AccountResponse, CommonError> {
        return NetworkProvider.shared.request(.verifyEmail(email: email, action))
            .decode(type: AccountResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func register(for user: User, with account: Account, restaurant: Restaurant? = nil) -> AnyPublisher<AccountResponse, CommonError>  {
        var params: Parameters = [:]
        if let userJS = try? user.toParameters(), let accountJS = try? account.toParameters() {
            params["user"] = userJS
            params["account"] = accountJS
            if restaurant != nil {
                guard let resJS = try? restaurant?.toParameters() else {
                    return Fail(error: .invalidInputData).eraseToAnyPublisher()
                }
                params["restaurant"] = resJS
            }
        } else {
            return Fail(error: .invalidInputData).eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.register(params))
            .decode(type: AccountResponse.self)
            .eraseToAnyPublisher()
    }
    
    struct LoginResponse: Decodable {
        var accessToken: String?
        var user: User?
    }
    
    static func login(email: String, password: String) -> AnyPublisher<LoginResponse, CommonError>  {
        NetworkProvider.shared.request(.login(email, password))
            .decode(type: LoginResponse.self)
            .eraseToAnyPublisher()
    }
    
    struct InfoResponse: Decodable {
        var user: User = User()
        var restaurant: Restaurant?
    }
    
    static func getInformation() -> AnyPublisher<InfoResponse, CommonError>  {
        NetworkProvider.shared.request(.me)
            .decode(type: InfoResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func getUserInformation(id: String) -> AnyPublisher<User, CommonError>  {
        NetworkProvider.shared.request(.userInfo(id))
            .decode(type: User.self)
            .eraseToAnyPublisher()
    }
    
    static func updateInfo(_ params: Parameters) -> AnyPublisher<InfoResponse, CommonError> {
        NetworkProvider.shared.request(.updateInfo(params))
            .decode(type: InfoResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func logout() {
        try? Auth.auth().signOut()
    }
}

extension AccountService {
    static func refreshToken() -> AnyPublisher<LoginResponse, CommonError>  {
        NetworkProvider.shared.request(.refreshToken)
            .decode(type: LoginResponse.self)
            .eraseToAnyPublisher()
    }
}

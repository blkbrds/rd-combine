//
//  SignInValidator.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/12/21.
//

import Combine

enum ValidationResult {
    case success
    case failure(SignInError)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

typealias ValidationPublisher = AnyPublisher<ValidationResult, Never>

final class SignInValidator {
    
    func validateUsername(for publisher: Published<String>.Publisher) -> ValidationPublisher {
        publisher
            .map {
                if $0.count < 2 || $0.count > 20 {
                    return .failure(.invalidUsernameLength)
                }
                if $0.containsEmoji {
                    return .failure(.invalidUsername)
                }
                return .success
            }
            .eraseToAnyPublisher()
    }
    
    func validatePassword(for publisher: Published<String>.Publisher) -> ValidationPublisher {
        publisher
            .map {
                if $0.count < 8 || $0.count > 20 {
                    return .failure(.invalidPasswordLength)
                }
                return .success
            }
            .eraseToAnyPublisher()
    }
}

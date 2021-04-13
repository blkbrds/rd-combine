//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    
    // input
    @Published var username = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    // output
    @Published var usernameMessage = ""
    @Published var passwordMessage = ""
    @Published var isValid = false
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
      $username
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { input in
            return LocalDatabase.users.contains(where: {$0.name == input })
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
      $password
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { password in
          return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordStrengthPublisher: AnyPublisher<Bool, Never> {
      $password
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { input in
            return input == "12345678"
        }
        .eraseToAnyPublisher()
    }

    
    enum PasswordCheck {
      case valid
      case empty
      case notStrongEnough
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
      Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordStrengthPublisher)
        .map { passwordIsEmpty, passwordIsStrongEnough in
          if (passwordIsEmpty) {
            return .empty
          }
          else if !passwordIsStrongEnough {
            return .notStrongEnough
          }
          else {
            return .valid
          }
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
        .map { userNameIsValid, passwordIsValid in
          return userNameIsValid && (passwordIsValid == .valid)
        }
      .eraseToAnyPublisher()
    }
    
    init() {
      isUsernameValidPublisher
        .receive(on: RunLoop.main)
        .map { valid in
          valid ? "" : "User must correct"
        }
        .assign(to: \.usernameMessage, on: self)
        .store(in: &cancellableSet)
      
      isPasswordValidPublisher
        .receive(on: RunLoop.main)
        .map { passwordCheck in
          switch passwordCheck {
          case .empty:
            return "Password must not be empty"
          case .notStrongEnough:
            return "Password not strong enough"
          default:
            return ""
          }
        }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)

      isFormValidPublisher
        .receive(on: RunLoop.main)
        .assign(to: \.isValid, on: self)
        .store(in: &cancellableSet)
    }
}

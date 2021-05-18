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
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
      $password
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { input in
            return LocalDatabase.users.contains(where: {$0.password == input })
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
        .map { userNameIsValid, passwordIsValid in
          return userNameIsValid && passwordIsValid
        }
      .eraseToAnyPublisher()
    }
    
    init() {

      isFormValidPublisher
        .receive(on: RunLoop.main)
        .assign(to: \.isValid, on: self)
        .store(in: &cancellableSet)
    }
}

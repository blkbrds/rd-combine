//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    @Published var userName: String = ""
    @Published var password: String = ""
    private var usersAvailable: [User] = LocalDatabase.users

    var validatedUsername: AnyPublisher<String?, Never> {
        return $userName
            .flatMap { username in
                return Future { promise in
                    self.usernameAvailable(username) { available, messageError  in
                        promise(.success(available ? username : messageError))
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    var validatedPassword: AnyPublisher<String?, Never> {
      return $password
        .flatMap { password in
          return Future { promise in
            self.passwordAvailable(password) { available, msgError in
              promise(.success(available ? password : msgError))
            }
          }
      }
      .eraseToAnyPublisher()
    }

    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validatedUsername, validatedPassword)
            .map { name, pass in
                guard let name = name, let pass = pass else {
                    return nil
                }
                return (name, pass)
            }
            .eraseToAnyPublisher()
    }

    func enableSignInButton(_ userName: String, _ password: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            completion(self.usersAvailable.contains(where: { userName == $0.name && password == $0.password }))
        }
    }

    func usernameAvailable(_ username: String, completion: @escaping (Bool, String?) -> ()) -> () {
      DispatchQueue.main .async {
        let isValid = ((2...20) ~= username.count && !username.containsEmoji)
        if isValid {
            completion(isValid, nil)
        } else {
            if !username.containsEmoji {
                completion(false, SignInError.invalidUsername.message)
            }
            if (2...20) ~= username.count {
                completion(false, SignInError.invalidUsernameLength.message)
            }
        }
      }
    }

    func passwordAvailable(_ username: String, completion: @escaping (Bool, String?) -> ()) -> () {
      DispatchQueue.main .async {
        completion((8...20) ~= username.count, ((8...20) ~= username.count) ? nil : SignInError.invalidPasswordLength.message)
      }
    }
}

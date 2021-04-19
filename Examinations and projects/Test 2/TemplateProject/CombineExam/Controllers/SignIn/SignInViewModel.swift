//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine


final class SignInViewModel {
    
    @Published var userName = ""
    @Published var passWord = ""
    
    let user = LocalDatabase()
    let usernameMessagePublisher = PassthroughSubject<String, Never>()
    let passwordMessagePublisher = PassthroughSubject<String, Never>()
    
    var validatedUsername: AnyPublisher<String?, Never> {
        return $userName
            .map { name in
                
                guard name.count != 0 else {
                    
                    self.usernameMessagePublisher.send("\(SignInError.invalidUsername)")
                    return nil
                }
                
                guard name.count < 3  || name.count > 20 else {
                    
                    self.usernameMessagePublisher.send("\(SignInError.invalidUsernameLength)")
                    return nil
                }
                
                guard name.containsEmoji else {
                    self.usernameMessagePublisher.send("\(SignInError.invalidUsername)")
                    return nil
                }
                self.usernameMessagePublisher.send("")
                return name
        }
        .eraseToAnyPublisher()
    }
    
    var validatedPassword: AnyPublisher<String?, Never> {
        
        return $passWord
            .receive(on: RunLoop.main)
            .map { pass in
                
                guard pass.count != 0 else {
                    self.passwordMessagePublisher.send("\(SignInError.invalidPasswordLength)")
                    return nil
                }
                
                guard pass.count < 8  || pass.count > 20 else {
                    
                    self.usernameMessagePublisher.send("\(SignInError.invalidPasswordLength)")
                    return nil
                }
                
                self.passwordMessagePublisher.send("\(SignInError.unknown)")
                
                return pass
        }
        .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
        
        return Publishers.CombineLatest(validatedUsername, validatedPassword)
            .map { name, pass in
                
                guard let  name = name, let pass = pass else {
                    return nil
                }
                return (name, pass)
        }
        .eraseToAnyPublisher()
    }
}

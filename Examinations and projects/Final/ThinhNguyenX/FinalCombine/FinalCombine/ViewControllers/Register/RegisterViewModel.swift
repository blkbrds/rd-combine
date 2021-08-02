//
//  RegisterViewModel.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 8/2/21.
//

import Foundation
import Combine

final class RegisterViewModel {

    // MARK: - Properties
    @Published var username: String?
    @Published var password: String?
    @Published var confirmPW: String?
    @Published var age: String?
    @Published var gender: String?
    @Published var isRegister: Bool = false

    var validatedText1: AnyPublisher<Bool, Never> {
       return Publishers.CombineLatest($username, $password)
        .map { (($0?.isEmpty) != nil || (($1?.isEmpty) != nil)) }
         .eraseToAnyPublisher()
     }

    var validatedText2: AnyPublisher<Bool, Never> {
       return Publishers.CombineLatest3($confirmPW, $age, $gender)
         .map { (($0?.isEmpty) != nil || ($1?.isEmpty) != nil || ($2?.isEmpty) != nil) }
         .eraseToAnyPublisher()
     }

    var fullValidation: AnyPublisher<Bool, Never> {
        validatedText1
            .zip(validatedText2)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }

    var stores: Set<AnyCancellable> = []
}

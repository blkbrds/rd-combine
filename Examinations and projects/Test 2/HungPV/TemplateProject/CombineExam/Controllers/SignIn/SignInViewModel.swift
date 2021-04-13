//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    var usernameValidate: CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(false)
    var passwordValidate: CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(false)
    var passwordText: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
}

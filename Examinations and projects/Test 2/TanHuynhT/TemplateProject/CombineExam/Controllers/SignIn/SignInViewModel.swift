//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    var subscription = Set<AnyCancellable>()
    var userNamesubject = PassthroughSubject<String, Never>()
    var passwordSubject = PassthroughSubject<String, Never>()
}

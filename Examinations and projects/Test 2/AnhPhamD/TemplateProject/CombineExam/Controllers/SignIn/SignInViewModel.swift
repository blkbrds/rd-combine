//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    
    var subcriptions = Set<AnyCancellable>()
    var userNameSubject = PassthroughSubject<String, Never>()
    var passWordSubject = PassthroughSubject<String, Never>()
}

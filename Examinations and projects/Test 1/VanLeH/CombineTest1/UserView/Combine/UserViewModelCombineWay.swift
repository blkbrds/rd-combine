//
//  UserViewModelCombineWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

final class UserViewModelCombineWay: UserViewModel {

    var editButtonTitle: String
    var userSubject: CurrentValueSubject<User, Never>

    init(editButtonTitle: String, user: User) {
        self.editButtonTitle = editButtonTitle
        self.userSubject = CurrentValueSubject<User, Never>(user)
    }
}

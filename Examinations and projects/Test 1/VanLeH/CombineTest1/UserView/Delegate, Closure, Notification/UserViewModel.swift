//
//  UserViewModel.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation

protocol UserViewModel {
    var editButtonTitle: String { get set }
}

final class UserViewModelNormalWay: UserViewModel {

    var editButtonTitle: String
    var user: User

    init(editButtonTitle: String, user: User) {
        self.editButtonTitle = editButtonTitle
        self.user = user
    }
}

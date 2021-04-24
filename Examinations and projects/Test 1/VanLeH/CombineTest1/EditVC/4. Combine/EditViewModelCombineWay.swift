//
//  EditViewModelCombineWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

final class EditViewModelCombineWay: EditViewModel {

    var tag: Int
    var userSubject: CurrentValueSubject<User, Never> = CurrentValueSubject<User, Never>(User())

    init(tag: Int, user: User) {
        self.tag = tag
        self.userSubject.value = user
    }
}

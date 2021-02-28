//
//  EditViewModel.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation

protocol EditViewModel {
    var tag: Int { get set }
}

final class EditViewModelNormalWay: EditViewModel {

    var tag: Int
    var user: User

    init(tag: Int, user: User) {
        self.tag = tag
        self.user = user
    }
}

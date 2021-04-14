//
//  HomeViewCellModel.swift
//  CombineExam
//
//  Created by Hung Pham V. on 4/14/21.
//

import Foundation

final class HomeViewCellModel {

    var username: String
    var address: String

    init(users: User) {
        self.username = users.name
        self.address = users.address
    }
}

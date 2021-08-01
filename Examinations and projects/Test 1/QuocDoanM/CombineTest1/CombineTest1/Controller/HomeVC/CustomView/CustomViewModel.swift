//
//  CustomViewModel.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import Foundation

final class CustomViewModel {

    var user: User
    var descriptionEdit: String

    init(user: User, descriptionEdit: String) {
        self.user = user
        self.descriptionEdit = descriptionEdit
    }
}

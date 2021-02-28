//
//  EditViewModel.swift
//  QueDinhT
//
//  Created by MBA0023 on 2/28/21.
//

import Foundation

final class EditViewModel {
    var editType: EditType = .delegate
    var user: User

    init(editType: EditType, user: User) {
        self.editType = editType
        self.user = user
    }
}

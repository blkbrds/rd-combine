//
//  EditViewModel.swift
//  Test1
//
//  Created by MBA0225 on 3/1/21.
//

import Foundation

final class EditViewModel {

    var name: String
    var address: String
    var tagEdit: Int

    init(name: String = "", address: String = "", tagEdit: Int = 0) {
        self.name = name
        self.address = address
        self.tagEdit = tagEdit
    }
}

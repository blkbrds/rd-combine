//
//  EditViewModel.swift
//  CombineTest1
//
//  Created by MBA0253P on 2/28/21.
//

import Foundation

final class EditViewModel {
    var name: String
    var address: String
    var tagEdit: Int
    
    init(name: String = "", address: String = "", tagEdit: Int = 1) {
        self.name = name
        self.address = address
        self.tagEdit = tagEdit
    }
}

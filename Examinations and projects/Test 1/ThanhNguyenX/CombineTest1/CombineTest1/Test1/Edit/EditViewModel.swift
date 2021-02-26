//
//  EditViewModel.swift
//  CombineTest1
//
//  Created by Thanh Nguyen X. on 02/26/21.
//

import Foundation

final class EditViewModel {
    var human: Human
    var editType: EditType
    var updateData: Human?

    init(human: Human = Human(name: "", address: ""), editType: EditType = .delegate) {
        self.human = human
        self.editType = editType
    }
}

//
//  EditViewModel.swift
//  CombineTest1
//
//  Created by NganHa on 28/02/2021.
//

import Foundation

final class EditViewModel {

    private(set) var editCase: EditCase
    private(set) var name: String = ""
    private(set) var address: String = ""

    init(editCase: EditCase) {
        self.editCase = editCase
    }
}

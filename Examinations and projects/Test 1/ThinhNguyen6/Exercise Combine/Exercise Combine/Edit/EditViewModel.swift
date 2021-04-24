//
//  EditViewModel.swift
//  Exercise Combine
//
//  Created by MBA0052 on 2/28/21.
//

import Foundation

class EditViewModel {
    var name: String
    var address: String
    init(name: String =  "", address: String = "") {
        self.address = address
        self.name = name
    }
}

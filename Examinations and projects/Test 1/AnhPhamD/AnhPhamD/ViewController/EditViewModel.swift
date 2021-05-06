//
//  EditViewModel.swift
//  AnhPhamD
//
//  Created by AnhPhamD. [2] on 2/28/21.
//  Copyright © 2021 AnhPhamD. [2]. All rights reserved.
//

import Foundation

final class EditViewModel {
    var name: String
    var address: String
     var tagNumber: Int

    init(name: String, address: String, tagNumber: Int) {
        self.name = name
        self.address = address
        self.tagNumber = tagNumber
    }
}

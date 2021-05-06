//
//  EditViewModel.swift
//  BaiTapCombine
//
//  Created by Trin Nguyen X on 2/28/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation

final class EditViewModel {
    var name: String
    var address: String
    var tagNumber: Int

    init(name: String = "", address: String = "", tagNumber: Int = 1) {
        self.name = name
        self.address = address
        self.tagNumber = tagNumber
    }
}

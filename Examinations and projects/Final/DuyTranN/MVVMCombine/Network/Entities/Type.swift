//
//  Type.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Type: Decodable, Hashable {
    var id: String
    var label: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Type, rhs: Type) -> Bool {
        return lhs.id.elementsEqual(rhs.id)
    }
}

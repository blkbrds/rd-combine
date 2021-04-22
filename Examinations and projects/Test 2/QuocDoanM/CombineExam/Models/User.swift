//
//  User.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation

struct User: Hashable {
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var password: String = "12345678"
}

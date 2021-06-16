//
//  OptionalExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import Foundation

extension Optional {

    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        if let value: Wrapped = self {
            return value
        }
        return defaultValue
    }
}

extension Optional where Wrapped == String {

    var orEmpty: String {
        if let value: String = self {
            return value
        }
        return ""
    }

    var isNilOrEmpty: Bool {
        switch self {
        case let .some(value): return value.isEmpty
        default: return true
        }
    }
}

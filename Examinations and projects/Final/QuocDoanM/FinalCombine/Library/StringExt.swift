//
//  StringExt.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/13/21.
//

import UIKit
import Combine

extension Optional where Wrapped == String {
    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    var containsEmoji: Bool { contains { $0.isEmoji } }
}

func / (lhs: String, rhs: String) -> String {
    return lhs + "/" + rhs
}

//
//  CollectionExt.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/28/21.
//

import UIKit

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Array where Iterator.Element: Equatable {
    mutating func remove(item: Iterator.Element) {
        if let ind = firstIndex(of: item) {
            remove(at: ind)
        }
    }
}

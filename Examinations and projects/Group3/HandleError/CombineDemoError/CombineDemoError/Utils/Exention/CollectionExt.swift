//
//  CollectionExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import Foundation

extension Collection {

    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

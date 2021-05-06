//
//  Collection+Extensions.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/28/21.
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

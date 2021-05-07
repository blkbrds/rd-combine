//
//  Collection+Extensions.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/12/21.
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

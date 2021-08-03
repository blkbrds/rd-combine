//
//  Array.swift
//  Foody
//
//  Created by MBA0283F on 3/15/21.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

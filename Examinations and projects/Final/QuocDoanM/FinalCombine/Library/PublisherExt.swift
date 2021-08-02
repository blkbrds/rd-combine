//
//  PublisherExt.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/28/21.
//

import Foundation
import Combine

extension Publisher {
    func element<T: Collection>(at index: T.Index) -> Publishers.CompactMap<Self, T.Element> where Output == T {
        return self
            .compactMap {
                $0[safe: index]
            }
    }
}

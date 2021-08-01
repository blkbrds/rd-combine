//
//  HomeViewCellVM.swift
//  CombineExam
//
//  Created by Thanh Nguyen X. on 04/14/21.
//

import Foundation
import Combine

final class HomeViewCellVM {
    var name: String
    var address: String

    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

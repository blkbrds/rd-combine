//
//  HomeTableCellVM.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/27/21.
//

import Foundation

final class HomeTableCellVM {
    var name: String
    var address: String
    var imageURL: String

    init(name: String, address: String, imageURL: String) {
        self.name = name
        self.address = address
        self.imageURL = imageURL
    }
}

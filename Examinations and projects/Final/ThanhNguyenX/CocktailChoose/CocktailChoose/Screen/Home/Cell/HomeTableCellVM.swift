//
//  HomeTableCellVM.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/27/21.
//

import Foundation

final class HomeTableCellVM {
    var title: String
    var description: String
    var imageURL: String

    init(title: String, description: String, imageURL: String) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

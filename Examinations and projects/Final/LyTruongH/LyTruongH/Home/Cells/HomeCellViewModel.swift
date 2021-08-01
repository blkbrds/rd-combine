//
//  HomeCellViewModel.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 29/07/2021.
//

import Foundation

final class HomeCellViewModel {
    var name: String
    var thumnailUrl: String
    var description: String
    
    init(name: String, thumnailUrl: String, description: String) {
        self.name = name
        self.thumnailUrl = thumnailUrl
        self.description = description
    }
}

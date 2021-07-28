//
//  MusicTableViewCellModel.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/19/21.
//

import Foundation

final class MusicTableViewCellModel {
    var name: String
    var artistName: String
    var urlImage: String
    
    init(name: String, artistName: String, urlImage: String) {
        self.name = name
        self.artistName = artistName
        self.urlImage = urlImage
    }
}

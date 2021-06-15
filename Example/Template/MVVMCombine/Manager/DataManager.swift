//
//  DataManager.swift
//  MVVMCombine
//
//  Created by Van Le H. on 5/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class DataManager {

    enum FileExtension: String {
        case json
        case png
        case propertyList = "plist"
        case text = "txt"
    }

    static func getItemList<T: Decodable>(fileName: String, fileExtension: FileExtension) -> [T] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension.rawValue),
              let data = try? Data(contentsOf: url),
              let itemList = try? PropertyListDecoder().decode([T].self, from: data)
        else { return [] }
        return itemList
    }
}

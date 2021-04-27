//
//  Error.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation

enum APIError: Error, Identifiable {
    var id: String { UUID().uuidString }
    
    case invalidServerResponse
    case unknow(String)
}

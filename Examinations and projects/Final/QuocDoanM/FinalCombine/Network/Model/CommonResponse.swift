//
//  CommonResponse.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import UIKit

class CommonResponse<T: Decodable> : Decodable {
    var count: Int = 0
    var next: String?
    var previous: String?
    var results: [T] = []
}

//
//  DateExt.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/27/21.
//

import Foundation

extension Date {

    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        return dateFormatter.string(from: self)
    }
}

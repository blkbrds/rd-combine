//
//  DateExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import UIKit

extension Date {

    func toString(withFormat type: DateFormatter.DateFormatType, dateFormatter: DateFormatter = .withLocalTimeZone()) -> String {
        let dateFormatter: DateFormatter = dateFormatter
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}

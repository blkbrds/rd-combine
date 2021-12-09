//
//  Date+Extensions.swift
//  Marvel
//
//  Created by Cuong Doan M. on 4/23/21.
//

import Foundation

extension Date {
    
    func toString(withFormat type: DateFormatter.DateFormatType, dateFormatter: DateFormatter = .withLocalTimeZone()) -> String {
        let dateFormatter: DateFormatter = dateFormatter
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}

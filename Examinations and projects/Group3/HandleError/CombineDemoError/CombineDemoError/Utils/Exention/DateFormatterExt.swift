//
//  DateFormatterExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import Foundation
extension DateFormatter {

    enum DateFormatType: String {
        case full = "yyyy-MM-dd HH:mm:ss"
        case date = "yyyy-MM-dd"
    }

    private static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()

    static func withUTCTimeZone() -> DateFormatter {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }

    static func withUTCTimeZone(withFormat type: DateFormatType) -> DateFormatter {
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }

    static func withLocalTimeZone() -> DateFormatter {
        dateFormatter.timeZone = .current
        return dateFormatter
    }

    static func withLocalTimeZone(withFormat type: DateFormatType) -> DateFormatter {
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = .current
        return dateFormatter
    }
}

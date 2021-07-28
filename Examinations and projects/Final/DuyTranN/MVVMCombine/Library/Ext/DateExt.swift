//
//  DateExt.swift
//  MVVMCombine
//
//  Created by Trin Nguyen X on 5/21/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1_000).rounded())
    }

    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1_000)
    }

    func dateToString(formatString: String, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        formatter.calendar = calendar
        return formatter.string(from: self)
    }
}

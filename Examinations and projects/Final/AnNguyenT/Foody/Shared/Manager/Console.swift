//
//  Console.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import Foundation
import os

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// Logs the notification like enable or disable.
    static let notification = Logger(subsystem: subsystem, category: "lg_notification")
}

final class Console {
    
    enum Category {
        case `default`
        case notification
    }
    
    static func log(_ msg: Any, category: Category, level: OSLogType = .default) {
        #if DEBUG
        switch category {
        case .notification:
            let message = String(describing: msg)
            Logger.notification.log(level: level, "\(message)")
        default:
            let message = String(describing: msg)
            Logger().log(level: level, "\(message)")
        }
        #endif
    }
}

//
//  Constants.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/28/21.
//

import Foundation

enum Pattern: Int {
    case delegate = 0, closure, notification, combine
    
    var name: String {
        switch self {
        case .delegate: return "Delegate"
        case .closure: return "Closure"
        case .notification: return "Notification"
        case .combine: return "Combine"
        }
    }
}

enum Action<Value> {
    case edit
    case update(Value)
}

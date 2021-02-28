//
//  Manager.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import UIKit

public enum PassDataType: Int, CaseIterable {
    case delegate = 0
    case closure
    case notification
    case combine

    var title: String {
        switch self {
        case .delegate: return "Delegate"
        case .closure: return "Closure"
        case .notification: return "Notification"
        case .combine: return "Combine"
        }
    }
}

final class Manager {
    static let shared: Manager = Manager()
    
}

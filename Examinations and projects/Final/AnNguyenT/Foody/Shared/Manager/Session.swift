//
//  Session.swift
//  Foody
//
//  Created by MBA0283F on 3/15/21.
//

import Foundation
import SwiftyUserDefaults

final class Session {
    private init() { }
    static let shared = Session()
    
    var user: User? {
        set {
            Defaults.currentUser = newValue
        } get {
            Defaults.currentUser
        }
    }
    
    var accessToken: String? {
        set {
            Defaults.accessToken = newValue
        } get {
            Defaults.accessToken
        }
    }
    
    var isShowedOnboarding: Bool {
        set {
            Defaults.isShowedOnboarding = newValue
        } get {
            Defaults.isShowedOnboarding
        }
    }
    
    var currentEmail: String {
        set {
            Defaults.currentEmail = newValue
        } get {
            Defaults.currentEmail
        }
    }
    
    var isResraurant: Bool {
        user?.type == UserType.restaurant.rawValue
    }
    
    var restaurant: Restaurant? {
        set {
            Defaults.restaurant = newValue
        } get {
            Defaults.restaurant
        }
    }
    
    var favorites: [Product] = []
    
    var haveNotifications: Bool = false
    
    var currentTab: Int = 0
    
    var blacklist: [WarningUser] = []
}

extension Session {
    func reset() {
        blacklist = []
        haveNotifications = false
        favorites = []
        user = nil
        accessToken = nil
        currentEmail = ""
    }
}


enum Language: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case english = "English"
    case vietnamese = "Vietnamese"
    
    var value: String {
        switch self {
        case .english:
            return "en"
        case .vietnamese:
            return "vi"
        }
    }
}

extension Session {
    var language: Language {
        get {
            if let value = UserDefaults.standard.string(forKey: "language"),
               let lg = Language(rawValue: value) {
                return lg
            } else {
                return .english
            }
        } set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
        }
    }
}

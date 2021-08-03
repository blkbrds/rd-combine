//
//  AppSettings.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI

final class AppSettings: ObservableObject {

    @Published var language: Language {
        didSet {
            Session.shared.language = language
        }
    }

    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    init() {
        language = Session.shared.language
    }
}

//
//  TokenColor.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI


// MARK: - Base color
struct BaseColor {
    /// dynamic color sets (with dark and light mode)
    let backgroundPrimary = Color("backgroundPrimary")
    let textPrimary = Color("textPrimary")
    let themePrimary = Color("themePrimary")
    
    struct Toast {
        let text = Color("toastText")
        let background = Color("toastBackground")
    }
}

struct TokenColor {
    let baseColor = BaseColor()
    
    let inactive: Color!
    
    let textDefault: Color!
    
    let buttonTheme: Color!
    
    let backgroundDefault: Color!
    let toast = BaseColor.Toast()
    
    init() {
        self.buttonTheme = baseColor.themePrimary
        self.textDefault = baseColor.textPrimary
        self.backgroundDefault = baseColor.backgroundPrimary
        self.inactive = .gray
    }
}

// MARK: - Add palatte to Color struct
extension Color {
    static let Token = TokenColor()
}

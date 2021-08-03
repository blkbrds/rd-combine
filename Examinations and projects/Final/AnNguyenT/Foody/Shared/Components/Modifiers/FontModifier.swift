//
//  FontModifier.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI

struct FontModifier: ViewModifier {
    
    enum TextStyle {
        case title
        case body
        case price
        
        // Toast
        case toast
        
        var font: Font {
            switch self {
            case .title:
                return Font.Typography.sizingFont(font: .hiraginoSans, style: .bold, size: .large)
            case .body:
                return  Font.Typography.sizingFont(font: .hiraginoSans, style: .w3, size: .medium)
            case .price:
                return Font.Typography.sizingFont(font: .hiraginoSans, style: .w6, size: .large)
            case .toast:
                return Font.Typography.sizingFont(font: .hiraginoSans, style: .w6, size: .medium)
            }
        }
    }
    
    var textStyle: TextStyle
    
    func body(content: Content) -> some View {
        return content.font(textStyle.font)
    }
}

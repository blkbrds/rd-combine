//
//  FontExt.swift
//  Foody
//
//  Created by An Nguyễn on 2/27/21.
//

import SwiftUI

struct BoldViewModifier: ViewModifier {
    var size: CGFloat = 18
    var relativeTo: Font.TextStyle = .body
    
    func body(content: Content) -> some View {
        content
            .font(.custom(Fonts.sourceSansProBold, size: size, relativeTo: .body))
    }
}

struct RegularViewModifier: ViewModifier {
    var size: CGFloat = 15
    
    func body(content: Content) -> some View {
        content
            .font(.custom(Fonts.sourceSansProRegular, size: size, relativeTo: .body))
    }
}

extension View {
    func bold(size: CGFloat) -> some View {
        modifier(BoldViewModifier(size: size))
    }
    
    func regular(size: CGFloat) -> some View {
        modifier(RegularViewModifier(size: size))
    }
    
    func systemBold(size: CGFloat) -> some View {
        self
            .font(.system(size: size, weight: .bold, design: .default))
    }
}


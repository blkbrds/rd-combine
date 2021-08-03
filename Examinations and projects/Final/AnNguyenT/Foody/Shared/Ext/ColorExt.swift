//
//  ColorExt.swift
//  Foody
//
//  Created by An Nguyễn on 2/27/21.
//

import SwiftUI

extension UIColor {
    var color: Color {
        Color(self)
    }
}

extension Color {
    var toUIColor: UIColor {
        UIColor(self)
    }
}

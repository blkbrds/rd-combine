//
//  ShapeExt.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI

extension Shape {
    /// fills and strokes a shape
    public func fill<S: ShapeStyle>(_ fillContent: S, stroke: StrokeStyle) -> some View {
        ZStack {
            self.fill(fillContent)
            self.stroke(style:stroke)
        }
    }
}

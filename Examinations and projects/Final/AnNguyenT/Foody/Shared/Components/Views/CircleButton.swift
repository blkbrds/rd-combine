//
//  CircleButton.swift
//  Foody
//
//  Created by An Nguyễn on 2/27/21.
//

import SwiftUI

struct CircleButton: View {
    var systemName: SFSymbols
    var color: Color = .black
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .bold, design: .default))
                .frame(width: 36, height: 36)
                .foregroundColor(color)
                .background(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1).color)
                .clipShape(Circle())
        })
    }
}

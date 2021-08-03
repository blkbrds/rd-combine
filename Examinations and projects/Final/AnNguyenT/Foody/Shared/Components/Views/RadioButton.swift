//
//  RadioButton.swift
//  Foody
//
//  Created by An Nguyễn on 24/04/2021.
//

import SwiftUI

struct RadioButton<Content: View>: View {
    var systemImageName: String
    var action: (() -> Void)?
    var content: Content
    @Binding var isSelected: Bool
    
    init(systemImageName: String = "checkmark", isSelected: Binding<Bool> = .constant(false),
         action: (() -> Void)? = nil, @ViewBuilder content: (() -> Content)) {
        self.systemImageName = systemImageName
        self.action = action
        self.content = content()
        self._isSelected = isSelected
    }
    
    @ViewBuilder
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            Image(systemName: systemImageName)
                .foregroundColor(isSelected ? Color.white: Color.clear)
                .font(.system(size: 15, weight: .bold, design: .default))
                .background(
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isSelected ? Color(#colorLiteral(red: 0, green: 0.4705882353, blue: 0.7725490196, alpha: 1)): Color(#colorLiteral(red: 0.7803921569, green: 0.9137254902, blue: 0.9568627451, alpha: 1)))
                )
                .padding([.leading, .vertical], 10)
                .padding(.trailing, -15)
            
            content
                .font(.system(size: 17, weight: .bold, design: .default))
                .frame(maxWidth: kScreenSize.width / 4)
                .foregroundColor(isSelected ? Color.white: Color.gray)
        })
        .background(
            isSelected ? AnyView(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.4705882353, blue: 0.7725490196, alpha: 1)), Color(#colorLiteral(red: 0.2941176471, green: 0.6274509804, blue: 0.8156862745, alpha: 1))]), startPoint: .bottom, endPoint: .top)):
                AnyView(Color(#colorLiteral(red: 0.831372549, green: 0.8039215686, blue: 0.8705882353, alpha: 1)))
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 35/2)
        )
    }
}

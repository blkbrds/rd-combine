//
//  ButtonCircleBackground.swift
//  Foody
//
//  Created by An Nguyễn on 28/04/2021.
//

import SwiftUI

struct ProfileButtonView: View {
    var action: (() -> Void)?
    var text: Text
    var imageName: String = ""
    var symbol: SFSymbols = .phone
    
    var iconImage: Image {
        imageName.isEmpty ? Image(systemName: symbol): Image(imageName)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                action?()
            }) {
                Label(
                    title: {
                        text
                            .padding(.leading, 30)
                            .font(.body)
                        
                        Spacer()
                    },
                    icon: {
                        iconImage
                            .resizable()
                            .frame(.init(width: 22, height: 22))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .frame(.init(width: 44, height: 44))
                                    .foregroundColor(Color(#colorLiteral(red: 0.1568627451, green: 0.1764705882, blue: 0.2117647059, alpha: 1)).opacity(0.9))
                            )
                    }
                )
            }
            
            Divider()
                .background(Color.black)
        }
        .padding([.top], 10)
        .padding(.horizontal)
        .foregroundColor(.black)
    }
}

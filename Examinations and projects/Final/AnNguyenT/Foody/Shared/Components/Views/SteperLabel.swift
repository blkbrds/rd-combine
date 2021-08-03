//
//  SteperLabel.swift
//  Foody
//
//  Created by An Nguyễn on 07/05/2021.
//

import SwiftUI

struct SteperLabel: View {
    @Binding var value: Int
    var range = 1...20
    var step: Int = 1
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                if value - step >= 1 {
                    value -= step
                }
            }, label: {
                Image(systemName: SFSymbols.minus)
                    .padding([.vertical, .leading], 5)
            })
            
            Text("\(value)")
                .frame(width: 20)
                .systemBold(size: 15)
            
            Button(action: {
                if value + step <= range.max() ?? 0 {
                    value += step
                }
            }, label: {
                Image(systemName: SFSymbols.plus)
                    .padding([.vertical, .trailing], 5)
            })
        }
        .systemBold(size: 13)
        .padding(3)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}

struct SteperLabel_Previews: PreviewProvider {
    static var previews: some View {
        SteperLabel(value: .constant(10))
    }
}

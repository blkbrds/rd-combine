//
//  BackButton.swift
//  Foody
//
//  Created by An Nguyễn on 4/5/21.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private var action: (() -> Void)?
    var icon: SFSymbols
    
    init(action: (() -> Void)? = nil, icon: SFSymbols) {
        self.action = action
        self.icon = icon
    }
    
    var body: some View {
        Button(action: {
            action?()
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: icon)
        })
        .font(.system(size: 18, weight: .bold, design: .default))
    }
}

//
//  Carts.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct CartsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.navibarColor
                    .ignoresSafeArea()
                NavigationLink("Hello", destination: Text("Helloooo!"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            .navigationTitle(Text("Carts"))
        }
        
    }
}

struct CartsView_Previews: PreviewProvider {
    static var previews: some View {
        CartsView()
    }
}

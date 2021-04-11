//
//  Favorites.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.navibarColor
                    .ignoresSafeArea()
                Text("Hello, World!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            .navigationTitle(Text("Favorites"))
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

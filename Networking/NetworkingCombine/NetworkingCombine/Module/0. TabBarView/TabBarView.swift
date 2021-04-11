//
//  TabBarView.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct TabBarView: View {
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            UIKitTabView(selectedIndex: $currentIndex){
                UIKitTabView.Tab(view: AnyView(HomeView()))
                UIKitTabView.Tab(view: AnyView(DiscoverView()))
                UIKitTabView.Tab(view: AnyView(CartsView()))
                UIKitTabView.Tab(view: AnyView(FavoritesView()))
                UIKitTabView.Tab(view: AnyView(ProfileView()))
            }
             
            TabBar(currentIndex: $currentIndex)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 90)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

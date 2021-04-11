//
//  DiscoverView.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct DiscoverView: View {
    
    init() {
        print("Create DiscoverView")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.navibarColor
                    .ignoresSafeArea()
                Text("Hello, World!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            .navigationTitle(Text("Discover"))
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}

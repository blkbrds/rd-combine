//
//  ProfileView.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.navibarColor
                    .ignoresSafeArea()
                Text("Hello, World!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            .navigationTitle(Text("Profile"))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//
//  HomeSearchView.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/9/21.
//

import SwiftUI

struct HomeSearchView: View {
    
    @Binding var textSearch: String
    var reloadData: (() -> Void)?

    var body: some View {
        ZStack {
            Color.navibarColor
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundColor(.gray)
                    .font(.title)
                    .padding(8)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        reloadData?()
                    }
                TextField("Search...", text: $textSearch)
                    .font(.title3)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 13)
        }
        .frame(height: 62)
    }
}

extension HomeSearchView {
    
    func reloadData(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.reloadData = action
        return copy
    }
}

extension Color {
    static let navibarColor = Color("navibar_color")
}

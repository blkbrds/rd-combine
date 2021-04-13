//
//  DrinksView.swift
//  NetworkingCombine
//
//  Created by MBA0283F on 4/12/21.
//

import SwiftUI
import Combine

struct DrinksView: View {
    @StateObject private var viewModel = DrinksViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter somethings...", text: $viewModel.text)
                .padding(.top, 20)
                .padding(.horizontal, 10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List(viewModel.drinks) { drink in
                DrinkCellView(drink: drink)
            }
        }
        .background(
            Image("Image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
    }
}

struct DrinksView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksView()
    }
}

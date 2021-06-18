//
//  DrinksView.swift
//  NetworkingCombine
//
//  Created by MBA0283F on 4/12/21.
//

import SwiftUI
import Combine

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct DrinksView: View {
    @StateObject private var viewModel = DrinksViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter somethings...", text: $viewModel.searchText)
                .padding(.top, 20)
                .padding(.horizontal, 10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            ZStack {
                List(viewModel.drinks) { drink in
                    DrinkCellView(drink: drink)
                }
                
                if viewModel.isLoading {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                        .frame(width: 70, height: 70)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.gray, radius: 3, x: 0, y: 0)
                }
            }
        }
        .background(
            Color.red
        )
        .alert(item: $viewModel.error, content: { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
        })
    }
}

struct DrinksView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksView()
    }
}

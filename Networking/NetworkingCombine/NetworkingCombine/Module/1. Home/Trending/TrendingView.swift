//
//  TrendingView.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct TrendingView: View {

    @StateObject private var viewModel = TrendingViewModel()
    @State private var foodDetailActive: Bool = false
    @Binding var isActive: Bool
    @Environment(\.presentationMode) private var presentationMode

    init(isActive: Binding<Bool> = .constant(false)) {
        _isActive = isActive
    }

    var body: some View {
        ZStack {
            Color.navibarColor
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50, maximum: (UIScreen.main.bounds.width - 15 * 3) / 2)),
                                         count: 2)) {
                    ForEach(viewModel.trendingRestaurants, id: \.self) { res in
                        ZStack {
                            NavigationLink(
                                destination: FoodDetailsView(isActive: $foodDetailActive, isRootActive: $isActive),
                                isActive: $foodDetailActive,
                                label: {
                                    
                                })
                            Cell(restaurant: res)
                                .onTapGesture {
                                    foodDetailActive = true
                                }
                        }
                    }
                }
                .padding(.vertical, 20)
                .disabled(viewModel.isLoading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            //Nav
            .navigationTitle(Text("Trending"))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "arrow.left")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                    })
            )
            
            if viewModel.isLoading {
                HUDView()
            }
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrendingView()
        }
    }
}

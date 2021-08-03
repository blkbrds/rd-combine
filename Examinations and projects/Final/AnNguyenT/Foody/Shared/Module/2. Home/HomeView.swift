//
//  HomeView.swift
//  Foody
//
//  Created by MBA0283F on 3/4/21.
//

import SwiftUI
import SwifterSwift

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isNotificationsPresented = false
        
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                Section(header: headerView("Trending products",  destination: TrendingProductsView().toAnyView)) {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 15) {
                            ForEach(viewModel.trendingProducts, id: \._id) { product in
                                NavigationLink(
                                    destination:
                                        FoodDetailsView(viewModel: viewModel.foodDetailViewModel(product)),
                                    label: {
                                        ProductCellView(product: product)
                                            .frame(width: 250, height: 270)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Section(header: headerView("Most popular", destination: PopularRestaurantsView().toAnyView)) {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.popularRestaurants, id: \._id) { restaurant in
                            NavigationLink(
                                destination:
                                    RestaurantDetailsView(viewModel: viewModel.restaurantDetailViewModel(restaurant)),
                                label: {
                                    RestaurantCellView(restaurant: restaurant)
                                }
                            )
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .onRefresh {
                viewModel.getHomeData()
            }
            .navigationBarItems(
                trailing: NotificationView(action: {
                    isNotificationsPresented.toggle()
                })
            )
            .navigationBarTitle("Home", displayMode: .automatic)
            .setupNavigationBar()
            .statusBarStyle(.lightContent)
            .handleHidenKeyboard()
            .handleErrors($viewModel.error)
            .addLoadingIcon($viewModel.isLoading)
            
            FloatButtonView()
            
        }
        .onAppear {
            if viewModel.trendingProducts.isEmpty {
                viewModel.setupData()
            }
        }
    }
}

extension HomeView {
    func headerView(_ title: String, destination: AnyView) -> some View {
        HStack {
            Text(title)
                .bold()
                .multilineTextAlignment(.leading)
                .font(.title3)
            
            Spacer()
            
            NavigationLink(
                destination: destination,
                label: {
                    Text("See more")
                        .underline()
                        .font(.body)
                })
        }
        .foregroundColor(.black)
        .padding([.horizontal, .top])
        .padding(.bottom, 5)
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}

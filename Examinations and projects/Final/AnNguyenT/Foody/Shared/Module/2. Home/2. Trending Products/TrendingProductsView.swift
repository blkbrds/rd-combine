//
//  TrendingProductsView.swift
//  Foody
//
//  Created by An Nguyễn on 05/05/2021.
//

import SwiftUI

struct TrendingProductsView: View {
    @StateObject private var viewModel = TrendingProductsViewModel()
    @State private var product: Product?
    @State private var isActiveDetails: Bool = false
    
    var body: some View {
        LazyVGrid(columns: defaultGridItemLayout, spacing: 10) {
            ForEach(viewModel.products, id: \._id) { product in
                NavigationLink(
                    destination: FoodDetailsView(viewModel: viewModel.detailsViewModel(product)),
                    label: {
                        ZStack(alignment: .topTrailing) {
                            ProductCellView(product: product)
                                .frame(height: 250)
                            
                            Button(action: {
                                if product.isLiked {
                                    self.product = product
                                } else {
                                    viewModel.addToFavorite(product)
                                }
                            }, label: {
                                Image(systemName: SFSymbols.heartFill)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(product.isLiked ? .red: .gray)
                                    .padding(8)
                            })
                        }
                        .frame(maxWidth: (kScreenSize.width - 15 * 3) / 2)
                        .onAppear(perform: {
                            if product == viewModel.products.last {
                                viewModel.isLastRow = true
                            }
                        })
                })
            }
        }
        .prepareForLoadMore(loadMore: {
            viewModel.handleLoadMore()
        }, showIndicator: viewModel.canLoadMore && viewModel.isLastRow)
        .onRefresh {
            viewModel.handleRefreshData()
        }
        .navigationBarTitle("Trending", displayMode: .inline)
        .setupNavigationBar()
        .statusBarStyle(.lightContent)
        .handleHidenKeyboard()
        .handleErrors($viewModel.error)
        .addLoadingIcon($viewModel.isLoading)
        .setupNavigationBar()
        .navigationBarBackButton()
        .addEmptyView(isEmpty: viewModel.products.isEmpty && !viewModel.isLoading)
        .alert(item: $product, content: { product in
            Alert(title: Text("Delete favorite"),
                  message: Text("Are you want to delete this item in your favorites?"),
                  primaryButton: .destructive(Text("Delete"), action: {
                    viewModel.deleteInFavorite(product)
                  }),
                  secondaryButton: .cancel()
            )
        })
    }
}

struct TrendingProductsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrendingProductsView()
        }
    }
}

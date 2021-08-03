//
//  FavoritesView.swift
//  Foody
//
//  Created by An Nguyễn on 2/28/21.
//

import SwiftUI
import SwiftUIX

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var isActiveDetails: Bool = false
    @State private var product: Product?
    
    var body: some View {
        LazyVGrid(columns: defaultGridItemLayout, spacing: 10) {
            ForEach(viewModel.products, id: \._id) { item in
                let product = item.product
                NavigationLink(
                    destination: FoodDetailsView(viewModel: viewModel.detailsViewModel(product)),
                    label: {
                        ZStack(alignment: .topTrailing) {
                            ProductCellView(product: product)
                                .frame(height: 250)
                            
                            Button(action: {
                                self.product = product
                            }, label: {
                                Image(systemName: SFSymbols.heartFill)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                                    .padding(8)
                                    
                            })
                        }
                        .frame(maxWidth: (kScreenSize.width - 15 * 3) / 2)
                        .onAppear(perform: {
                            if product == viewModel.products.last?.product {
                                viewModel.isLastRow = true
                            }
                        })
                    }
                )
            }
        }
        .prepareForLoadMore(loadMore: {
            handleLoadMore()
        }, showIndicator: viewModel.canLoadMore && viewModel.isLastRow)
        .onRefresh {
            handleRefresh()
        }
        .navigationBarTitle("Favorites", displayMode: .automatic)
        .setupNavigationBar()
        .addLoadingIcon($viewModel.isLoading)
        .handleErrors($viewModel.error)
        .statusBarStyle(.lightContent)
        .handleHidenKeyboard()
        .addEmptyView(isEmpty: viewModel.products.isEmpty && !viewModel.isLoading)
        .alert(item: $product, content: { product in
            Alert(title: Text("Delete favorite"),
                  message: Text("Are you want to delete this item in your favorites?"),
                  primaryButton: .destructive(Text("Delete"), action: {
                    viewModel.deleteFavorite(product)
                  }),
                  secondaryButton: .cancel()
            )
        })
    }
}

extension FavoritesView {
    private func handleRefresh() {
        viewModel.handleRefreshData()
    }
    
    private func handleLoadMore() {
        viewModel.handleLoadMore()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoritesView()
        }
    }
}

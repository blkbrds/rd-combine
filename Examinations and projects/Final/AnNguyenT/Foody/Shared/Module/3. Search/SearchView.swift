//
//  SearchView.swift
//  Foody
//
//  Created by MBA0283F on 3/19/21.
//

import SwiftUI
import SwiftUIX

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @State private var product: Product?
    
    var body: some View {
        VStack {
            HStack {
                Text("Total results: \(viewModel.products.count)")
                    .padding([.top, .horizontal] ,15)
                
                Spacer()
            }
            
            ZStack {
                LazyVGrid(columns: defaultGridItemLayout, spacing: 10) {
                    ForEach(viewModel.products, id: \._id) { product in
                        NavigationLink(
                            destination:
                                FoodDetailsView(viewModel: viewModel.detailsViewModel(product)),
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
                                .onAppear(perform: {
                                    if product == viewModel.products.last {
                                        viewModel.isLastRow = true
                                    }
                                })
                        })
                    }
                }
                .prepareForLoadMore(loadMore: {
                    handleLoadMore()
                }, showIndicator: viewModel.canLoadMore && viewModel.isLastRow)
                .onRefresh {
                    handleRefresh()
                }
                .addEmptyView(isEmpty:
                    viewModel.products.isEmpty, viewModel.searchText.isEmpty
                        ? "Please enter the name of the product you are looking for.": "No items found."
                )

                
                List {
                    ForEach(0..<viewModel.keywords.count, id: \.self) { index in
                        let keyword = viewModel.keywords[index].keyword
                        HStack {
                            Text("\(keyword)")
                                .onTapGesture {
                                    hideKeyboard()
                                    viewModel.searchText = keyword
                                    viewModel.searchProducts(with: keyword)
                                }
                            
                            Spacer()
                            
                            Image(systemName: SFSymbols.arrowUpLeft)
                            
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .hidden(viewModel.isHiddenKeywords)
            }
            
        }
        .navigationSearchBar({
            SearchBar("Search", text: $viewModel.searchText,
                      onEditingChanged: { isEditing in
                         viewModel.isHiddenKeywords = !isEditing
                      },
                      onCommit: {
                         let searchText = viewModel.searchText.trimmed
                         if !searchText.isEmpty {
                            viewModel.searchProducts(with: searchText)
                         }
                      }
            )
            .showsCancelButton(true)
            .searchBarStyle(.default)
            .returnKeyType(.search)
            .onCancel {
                viewModel.isLastRow = false
            }
        })
        .navigationBarTitle("Search", displayMode: .automatic)
        .setupNavigationBar()
        .statusBarStyle(.lightContent)
        .handleHidenKeyboard()
        .handleErrors($viewModel.error)
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

extension SearchView {
    
    private func handleRefresh() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            viewModel.handleRefreshData()
        }
    }
    
    private func handleLoadMore() {
        viewModel.handleLoadMore()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}

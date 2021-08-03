//
//  OrderView.swift
//  Foody
//
//  Created by MBA0283F on 4/8/21.
//

import SwiftUI

struct OrdersView: View {
    @StateObject private var viewModel = OrdersViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Picker("orders", selection: $viewModel.selectedIndex, content: {
                            Text("Pending").tag(2)
                            Text("Canceled").tag(0)
                            Text("Processing").tag(1)
                            Text("Shipping").tag(3)
                            Text("Payment").tag(4)
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding([.top, .horizontal], 10)
                    }
                    .frame(width: kScreenSize.width + 60, height: 50)
                }
                
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.currentOrders, id: \._id) { order in
                        NavigationLink(
                            destination: FoodDetailsView(viewModel: viewModel.detailsViewModel(order)),
                            label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        SDImageView(url: order.userProfile, isProfile: true)
                                            
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                            .shadow(radius: 2)
                                        
                                        VStack(alignment: .leading) {
                                            Text(order.username)
                                            
                                            Text(order.orderTime)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("Total: \(order.count)")
                                            .font(.body)
                                    }
                                    
                                    Divider()
                                        .padding(.vertical, 10)
                                    
                                    HStack(spacing: 10) {
                                        SDImageView(url: order.product.imageUrls.first)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))

                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Text(order.product.name)
                                                    .font(.title2)
                                            }
                                            
                                            HStack {
                                                Text("Price:")
                                                Text("\(order.product.price) vnđ")
                                                    .foregroundColor(.blue)
                                            }
                                            .font(.body)
                                            
                                            Text("Address: \(order.address)")
                                            
                                            HStack {
                                                Text("Phone:")
                                                Text(order.phoneNumber)
                                                    .underline()
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            Text("ID: \(order._id)")
                                                .foregroundColor(.gray)
                                            
                                            HStack {
                                                Text("Restaurant: \(order.product.restaurantName)")
                                                    .foregroundColor(.gray)
                                                
                                                Spacer()
                                                
                                                CircleButton(systemName: SFSymbols.xmark, color: .red,
                                                             action: {
                                                                viewModel.cancelOrder = order
                                                             })
                                                    .hidden(!order.isPending)
                                            }
                                        }
                                    }
                                }
                                .font(.caption)
                                .padding(10)
                                .lineLimit(1)
                                .frame(maxWidth: kScreenSize.width)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .gray, radius: 3)
                                .foregroundColor(.black)
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        print("Action 1 triggered")
                                    }, label: {
                                        Text("Delete")
                                    })
                                })
                            }
                        )
                    }
                    
                }
                .prepareForLoadMore(loadMore: {
                    
                }, showIndicator: false)
                .onRefresh {
                    viewModel.getOrders()
                }
                .addEmptyView(isEmpty: viewModel.currentOrders.isEmpty && !viewModel.isLoading)
            }
            .navigationBarTitle("My Orders", displayMode: .inline)
            .setupNavigationBar()
            .addLoadingIcon($viewModel.isLoading)
            .handleErrors($viewModel.error)
            .alert(item: $viewModel.cancelOrder) { (order) -> Alert in
                Alert(title: Text("Cancel order"),
                      message: Text("Do you want to cancel this order?"),
                      primaryButton: .destructive(Text("Continue"), action: {
                        viewModel.cancelOrder(order)
                      }),
                      secondaryButton: .cancel()
                )
            }
//            .navigationBarBackButton()
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.dismiss()
                }, label: {
                    Image(systemName: SFSymbols.xmark)
                        .foregroundColor(.white)
                        .padding(2)
                })
            )
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}

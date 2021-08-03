//
//  RestaurantView.swift
//  Foody
//
//  Created by An Nguyễn on 2/27/21.
//

import SwiftUI

struct RestaurantDetailsView: View {
    @StateObject var viewModel = RestaurantDetailsViewModel()
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(viewModel.restaurant.name)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                
                Text(viewModel.restaurant.address)
                
                HStack {
                    ForEach(0..<5) { _ in
                        Image(systemName: SFSymbols.starFill)
                            .foregroundColor(.yellow)
                    }
                    Text("( 245 reviews )")
                        .foregroundColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
                }
                
                HStack {
                    VStack {
                        Text("Delivery")
                        Text("Free")
                            .foregroundColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
                    }
                    VStack {
                        Text("Open time")
                        Text(viewModel.restaurant.openTime)
                            .foregroundColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
                    }
                }
                
                Group {
                    Divider()
                    HStack {
                        CircleButton(systemName:  SFSymbols.envelopeFill, color: .black,
                                     action: {
                                        openUrl(url: "mailto:annguyenit@gmail.com")
                                     })
                        
                        CircleButton(systemName: SFSymbols.phoneFill, color: .black,
                                     action: {
                                        openUrl(url: "tel://\(0398888888)")
                                     })
                        
                        CircleButton(systemName: SFSymbols.location, color: .black,
                                     action: {
                                        //comgooglemaps://?saddr=&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving"
                                        openUrl(url: "comgooglemaps://?center=\(16.060703561526726),\(108.19019829889342)&zoom=14&views=traffic")
                                     })
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Contact")
                                .frame(width: 113, height: 36)
                                .foregroundColor(Colors.redColorCustom)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 36 / 2)
                                        .stroke(Colors.redColorCustom, lineWidth: 2)
                                    
                                )
                        })
                    }
                    Divider()
                }
                
                HStack {
                    Text("Feature items:")
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("See more")
                        }
                    )
                    .disabled(true)
                }
                .padding(.vertical, 5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(viewModel.products, id: \.self) { product in
                            NavigationLink(
                                destination: FoodDetailsView(viewModel: viewModel.detailsViewModel(product)),
                                label: {
                                    VStack(alignment: .leading) {
                                        SDImageView(url: product.imageUrls.first)
                                            .frame(width: kScreenSize.width * 343 / 380, height: 160)
                                            .clipped()
                                        
                                        Text(product.name)
                                            .bold()
                                            .padding(.horizontal)
                                        
                                        Text("\(product.price) VNĐ")
                                            .foregroundColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
                                            .padding(.horizontal)
                                    }
                                    .font(.body)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: .gray, radius: 2, x: 0.0, y: 0)
                            })
                        }
                    }
                    .padding(.vertical)
                }
                .frame(maxWidth: kScreenSize.width, minHeight: 160)
                .addEmptyView(isEmpty: viewModel.products.isEmpty && !viewModel.isLoading)
            }
            .padding()
        }
        .setupNavigationBar()
        .handleErrors($viewModel.error)
        .addLoadingIcon($viewModel.isLoading)
        .navigationBarBackButton()
        .navigationBarTitle("Restaurant Details", displayMode: .inline)
    }
    
    private func openUrl(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            viewModel.error = .unknown("Can't open url!")
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView()
        }
    }
}

//
//  FoodDetails.swift
//  Foody
//
//  Created by An Nguyễn on 2/27/21.
//

import SwiftUI
import SwiftUIX

struct FoodDetailsView: View {
    @StateObject var viewModel = ProductDetailsViewModel()
    @State private var product: Product?
    @State private var isPresentedAppActivityView = false
    @State private var isPresentedOrderView = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(showsIndicators: false) {
                NavigationLink(destination: OrderView(viewModel: viewModel.orderViewModel),
                               isActive: $isPresentedOrderView, label: {
                                    EmptyView()
                               })
                VStack {
                    if viewModel.product.imageUrls.isEmpty {
                        Image(nil)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: kScreenSize.width, minHeight: 358)
                    } else {
                        TabView {
                            ForEach(viewModel.product.imageUrls, id: \.self) { url in
                                SDImageView(url: url)
                                    .frame(maxWidth: kScreenSize.width, minHeight: 358)
                                    .clipped()
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(maxWidth: kScreenSize.width, minHeight: 358)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(viewModel.product.name)
                                .bold(size: 30)
                                .lineLimit(2)
                            
                            Image(systemName: SFSymbols.checkmarkCircleFill)
                                .foregroundColor(viewModel.product.accepted ? .green: .gray)
                        }
                        
                        Text(viewModel.product.restaurantName)
                            .foregroundColor(.gray)
                            .font(.title3)
                        
                        Text(viewModel.product.address)
                            .font(.body)
                            .foregroundColor(.red)
                        
                        HStack(spacing: 3) {
                            Text("Description")
                                .font(.title3)
                            
                            Spacer()
                            
                            let voteCount = viewModel.product.myVote
                            ForEach(0..<5) { index in
                                Image(systemName: SFSymbols.starFill)
                                    .resizable()
                                    .frame(width: 20 * scale, height: 20 * scale)
                                    .foregroundColor(voteCount > index ? .yellow: .gray)
                                    .onTapGesture {
                                        if voteCount != index + 1 {
                                            viewModel.voteProduct(vote: index + 1)
                                        }
                                    }
                            }
                            Text(" \(viewModel.product.votes?.count ?? 0) votes")
                                .font(.body)
                        }
                        .padding(.top, 10)
                        
                        Text(viewModel.product.descriptions)
                            .foregroundColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).color)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                    }
                    .padding(.horizontal)
                                    
                    VStack {
                        Text("\(viewModel.product.price) VNĐ")
                            .bold(size: 20)
                        
                        Button(action: {
                            isPresentedOrderView.toggle()
                        }, label: {
                            ZStack {
                                Text("Add to order")
                                HStack {
                                    Spacer()
                                    Image(systemName: "creditcard")
                                        .font(.title3)
                                        .padding(.trailing, 10)
                                }
                            }
                            .regular(size: 17)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Colors.redColorCustom)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.top, 30)
                            
                        })
                    }
                    .padding(EdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 20))
                    
                    VStack(alignment: .leading) {
                        Group {
                            Divider()
                            Text("Reviews")
                                .font(.title3)
                        }
                        .padding(.horizontal)
                        
                        List {
                            ForEach(viewModel.comments, id: \._id) { comment in
                                CommentView(comment: comment)
                            }
                        }
                        .frame(height: viewModel.comments.isEmpty ? 150:
                                viewModel.comments.count < 5 ? viewModel.comments.count.cgFloat * 80: 400)
                        .addEmptyView(isEmpty: viewModel.comments.isEmpty && !viewModel.isLoading, "No customer has commented yet!")
                        
                        Divider()
                        
                        HStack {
                            TextField("Comment...", text: $viewModel.commentText)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .padding(.horizontal)
                                .border(cornerRadius: 20)
                            
                            Button(action: {
                                hideKeyboard()
                                viewModel.comment()
                            }, label: {
                                Image(systemName: SFSymbols.paperplaneFill)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            })
                            .disabled(viewModel.inValidComment)
                            .opacity(viewModel.inValidComment ? 0.5: 1)
                        }
                        .padding([.bottom, .horizontal])
                    }
                    .padding(.bottom, viewModel.comments.isEmpty ? 0: 10)
                }
                .regular(size: 15)
                .foregroundColor(#colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1568627451, alpha: 1).color)
                .offset(y: -viewModel.keyboardHeight)
                .animation(.easeInOut(duration: 0.4))
                .padding(.bottom, 10)
            }
            .ignoresSafeArea()
            
            HStack {
                BackButton(icon: .arrowLeft)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray.opacity(0.4))
                    )
                
                Spacer()
                
                CircleButton(systemName: SFSymbols.squareAndArrowUp, color: .black,
                             action: {
                                isPresentedAppActivityView = true
                             })
                
                CircleButton(systemName: SFSymbols.starFill, color: viewModel.product.isLiked ? .red: .gray,
                             action: {
                                if viewModel.product.isLiked {
                                    self.product = viewModel.product
                                } else {
                                    viewModel.addToFavorite(viewModel.product)
                                }
                             })
            }
            .padding(20)
        }
        .alert(item: $product, content: { product in
            Alert(title: Text("Delete favorite"),
                  message: Text("Are you want to delete this item in your favorites?"),
                  primaryButton: .destructive(Text("Delete"), action: {
                    viewModel.deleteInFavorite(product)
                  }),
                  secondaryButton: .cancel()
            )
        })
        .popover(isPresented: $isPresentedAppActivityView, content: {
            AppActivityView(activityItems: [
                    viewModel.product.name + " - " + viewModel.product.price.kFormatted,
                    viewModel.product.imageUrls.first ?? ""
                ]
            )
        })
        .navigationBarHidden(true)
        .handleHidenKeyboard()
        .handleErrors($viewModel.error)
        .addLoadingIcon($viewModel.isLoading)

    }
}

struct FoodDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView()
    }
}

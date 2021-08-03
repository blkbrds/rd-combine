//
//  OrderView.swift
//  Foody
//
//  Created by MBA0283F on 5/10/21.
//

import SwiftUIX

struct OrderView: View {
    @StateObject var viewModel = OrderViewModel()
    @Environment(\.presentationMode) private var presentationMode
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    Text("Username:")
                        .underline()
                    
                    Text(viewModel.user.username)
                        .font(.title2)
                    
                    Image(systemName: SFSymbolName.checkmarkCircleFill)
                        .foregroundColor(viewModel.user.isActive ?  .green: .gray)
                        .background(
                            Circle()
                                .foregroundColor(.white)
                        )
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                
                Text("Address:")
                    .underline()
                    .padding(.top, 10)
                
                TextView("", text: $viewModel.address)
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .padding([.horizontal, .vertical])
                    .border(cornerRadius: 15)
                
                Text("Phone number:")
                    .underline()
                    .padding(.top, 10)

                TextField("", text: .constant(viewModel.user.phoneNumber))
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .padding(.horizontal)
                    .border(cornerRadius: 46 / 2)
                    .keyboardType(.numberPad)
                    .disabled(true)
                    .opacity(0.6)
                
                HStack {
                    SDImageView(url: viewModel.product.imageUrls.first)
                        .frame(maxWidth: 130 * scale, minHeight: 130 * scale)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(viewModel.product.name)
                            .bold()
                        
                        Text(viewModel.product.restaurantName)
                            .foregroundColor(.gray)
                        
                        HStack {
                            HStack {
                                Text("\(viewModel.product.price)")
                                
                                Text("vnđ")
                                    .underline()
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Stepper(value: $viewModel.itemCount, in: 1...20, step: 1) {
                    Text("\(viewModel.itemCount) items")
                        .bold()
                }

                VStack {
                    Text("\(viewModel.product.price * viewModel.itemCount) VNĐ")
                        .bold(size: 20)
                    
                    Button(action: {
                        viewModel.handleOrder()
                    }, label: {
                        ZStack {
                            Text("Continue Order")
                            
                            HStack {
                                Spacer()
                                Image(systemName: SFSymbols.creditcard)
                                    .font(.title3)
                                    .padding(.trailing, 10)
                            }
                        }
                        .regular(size: 17)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Colors.redColorCustom)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 30)
                        .opacity(viewModel.inValidInfo ? 0.8: 1)
                    })
                    .disabled(viewModel.inValidInfo)
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
            }
            .padding()
            .font(.body)
        }
        .introspectScrollView(customize: { (scrollView) in
            scrollView.keyboardDismissMode = .onDrag
        })
        .handleErrors($viewModel.error)
        .addLoadingIcon($viewModel.isLoading)
        .setupNavigationBar()
        .navigationBarTitle("Order Infomation", displayMode: .inline)
        .navigationBarBackButton()
        .onReceive(viewModel.$isPresentedSuccessPopup, perform: { requested in
            if requested {
                handleShowNotiPupup()
            }
        })
//        .handleHidenKeyboard()
    }
}

extension OrderView {
    func handleShowNotiPupup() {
        presentView(
            AlertView(
                .constant(PopupContent(message: "Order request successful.", title: "Success"))
            )
            .onDisappear(perform: {
                presentationMode.wrappedValue.dismiss()
            })
        )
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderView()
        }
    }
}

//
//  ProfileView.swift
//  Foody
//
//  Created by MBA0283F on 3/19/21.
//

import SwiftUI
import SwiftUIX

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @State private var showAlertComfirm: Bool = false
    @State private var isPresentedAboutApp: Bool = false
    @AppStorage("AppState") private var state: AppState = .logged
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1607843137, green: 0.1803921569, blue: 0.2156862745, alpha: 1))
                .ignoresSafeArea()
            
            Color.white
                .padding(.top, kScreenSize.height / 3)
            
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                ZStack {
//                    Image(viewModel.restaurant.dataImages.first)
//                        .resizable()
//                        .frame(maxHeight: kScreenSize.height / 3.5)
//                        .clipShape(
//                            RoundedRectangle(cornerRadius: 20)
//                        )
//                        .shadow(color: Color.gray, radius: 2, x: 0, y: 0)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .frame(maxHeight: kScreenSize.height / 3.5)
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 0)
//                        .hidden(!viewModel.restaurant.dataImages.isEmpty)

                    VStack {
                        SDImageView(url: viewModel.user.imageProfile, isProfile: true)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 5))

                        HStack {
                            Text(viewModel.user.username)
                                .bold(size: 26)

                            Image(systemName: SFSymbolName.checkmarkCircleFill)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.green)
                                .background(
                                    Circle()
                                        .foregroundColor(.white)
                                )
                        }
                        Text(viewModel.user.email)
                            .bold(size: 17)
                    }
                    .padding(.vertical)

                    NavigationLink(
                        destination: UpdateInfoView(),
                        label: {
                            Image("edit-icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                        })
                        .offset(x: kScreenSize.width / 2 - 50, y: -kScreenSize.height / (3.5 * 2) + 30)
                        .foregroundColor(.gray)
                        .hidden(viewModel.userPreview != nil)
                }

                ScrollView(showsIndicators: false) {
                    if viewModel.isRestaurant {
                        ProfileButtonView(text: Text(viewModel.restaurant.name).bold(), symbol: SFSymbols.houseFill)
                            .padding(.top, 30)
                            .disabled(true)
                        
                        ProfileButtonView(text: Text("Open time: \(viewModel.restaurant.openTime) - \(viewModel.restaurant.closeTime)")
                                            .font(.caption)
                                            .foregroundColor(.red),
                                          symbol: SFSymbols.timer)
                            .disabled(true)
                    }

                    ProfileButtonView(text:
                                        Text(viewModel.user.phoneNumber)
                                            .foregroundColor(.blue),
                                      symbol: SFSymbols.phone)
                        .disabled(true)
                        .padding(.top, viewModel.isRestaurant ? 0: 30)
                    
                    ProfileButtonView(
                        text: Text(viewModel.userPreview != nil ? viewModel.user.address: viewModel.restaurant.address),
                        symbol: SFSymbols.locationFill
                    )
                    .disabled(true)
                    
                    if viewModel.userPreview != nil {
                        ProfileButtonView(action: {
                            isPresentedAboutApp.toggle()
                        }, text: Text("ID: \(viewModel.user._id)"), imageName: "info-icon")
                        
                        ProfileButtonView(action: {
                            openUrl(url: Config.helpUrl)
                        }, text: Text("Call Admin (Report)"), imageName: "help-icon")
                        
                        Button(action: {
                            showAlertComfirm.toggle()
                        }, label: {
                            Text("Add to Blacklist")
                                .bold(size: 18)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.337254902, alpha: 1)).opacity(viewModel.isInBlacklist ? 0.7: 1))
                                .foregroundColor(Color.white)
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical, 30)
                        .disabled(viewModel.isInBlacklist)
                    } else {
                        ZStack {
                            NavigationLink(
                                destination: AppInfomation(),
                                isActive: $isPresentedAboutApp,
                                label: {
                                    EmptyView()
                                })

                            
                            ProfileButtonView(action: {
                                isPresentedAboutApp.toggle()
                            }, text: Text("About application"), imageName: "info-icon")
                        }
                        
                        ProfileButtonView(action: {
                            openUrl(url: Config.helpUrl)
                        }, text: Text("Help"), imageName: "help-icon")
                        
                        ProfileButtonView(action: {
                            showAlertComfirm.toggle()
                        }, text: Text("Logout"), imageName: "logout-icon")
                        .padding(.bottom, 30)
                    }
                }
            }
            .padding([.horizontal, .top])
        }
        .alert(isPresented: $showAlertComfirm, content: {
            Alert(title: Text(viewModel.order != nil ? "Warning": "Logout"),
                  message: Text(
                    viewModel.order != nil ? "Do you want add current user to blacklist?": "You will log out of the application!"
                  ),
                  primaryButton: .destructive(
                    Text(viewModel.order != nil ? "OK": "Logout"), action: {
                        if viewModel.order != nil {
                            viewModel.addToBlacklist()
                        } else {
                            logout()
                        }
                    }),
                  secondaryButton: .cancel()
            )
        })
        .navigationBarHidden(true)
        .statusBarStyle(.lightContent)
        .addLoadingIcon($viewModel.isLoading)
        .handleErrors($viewModel.error)
        .onReceive(viewModel.$isLogged, perform: { isLogged in
            if !isLogged {
                state = .login
            }
        })
        .onAppear {
            viewModel.isLogged = true
        }
        .addBackBarCustom(viewModel.userPreview != nil ? .white: .clear)
    }
}

extension ProfileView {
    private func openUrl(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            viewModel.error = .unknown("Can't open url!")
        }
    }
    
    private func logout() {
        viewModel.logout()
    }
}

extension ProfileView {
    struct Config {
        // TODO: - UPDATE WEBSITE
        static let helpUrl: String = "tel://\(19008198)"
        static let applicationInfoUrl: String = "https://www.mongodb.com/"
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}

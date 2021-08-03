//
//  LoginView.swift
//  Foody
//
//  Created by An Nguyễn on 2/24/21.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @AppStorage("AppState") private var state: AppState = .logged
    
    var body: some View {
        ZStack {
            Image("bg_login")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Welcome back")
                        .bold(size: 44)
                    Text("Sign in to continue")
                        .regular(size: 18)
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                VStack(spacing: 30) {
                    TextFieldCustom(text: $viewModel.email,
                                    placeholder: Text("Email").foregroundColor(.gray))
                    
                    TextFieldCustom(text: $viewModel.password,
                                    placeholder: Text("Password").foregroundColor(.gray),
                                    onCommit: {
                                        handleLogin()
                                    }, isSecureField: true)

                }
                .layoutPriority(1)
                .regular(size: 18)
                .padding(.init(top: 50, leading: 20, bottom: 0, trailing: 20))
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button(action: {
                        handleLogin()
                    }, label: {
                        Text("Sign In")
                            .bold(size: 18)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .foregroundColor(Color.white.opacity(viewModel.invalidInfo ? 0.5: 1))
                            .background(Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.337254902, alpha: 1)).opacity(viewModel.invalidInfo ? 0.5: 0.7))
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(viewModel.invalidInfo)
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot password?")
                    }
                }
                .regular(size: 16)
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: RegisterView()) {
                        Text("Create one")
                            .underline()
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.bottom, .horizontal], 15)
                .regular(size: 16)
            }
        }
        .addLoadingIcon($viewModel.isLoading)
        .handleErrors($viewModel.error)
        .navigationBarHidden(true)
        .statusBarStyle(.lightContent)
        .foregroundColor(.white)
        .handleHidenKeyboard()
        .onReceive(viewModel.$isLogged, perform: { (isLogged) in
            if isLogged {
                state = .logged
            }
        })
    }
}

//MARK: - API
extension LoginView {
    private func handleLogin() {
        hideKeyboard()
        viewModel.login()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

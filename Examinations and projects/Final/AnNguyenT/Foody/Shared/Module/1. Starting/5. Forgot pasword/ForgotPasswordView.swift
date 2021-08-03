//
//  ForgotPasswordView.swift
//  Foody
//
//  Created by An Nguyễn on 4/5/21.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            NavigationLink(destination: VerifyPhoneView(viewModel: viewModel.verifyPhoneViewModel),
                           isActive: $viewModel.emailExist, label: { EmptyView() })
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Forgot password")
                        .bold(size: 34)
                    
                    Text("Enter your email address below and we'll send you an email with instructions on how to change your password.")
                        .regular(size: 17)
                    
                    TextFieldCustom(text: $viewModel.email,
                                    placeholder: Text("Your email").foregroundColor(.gray))
                        .padding(.top, 30)
                    
                    TextFieldCustom(text: $viewModel.newPassword,
                                    placeholder: Text("New password").foregroundColor(.gray),
                                    isSecureField: true)
                    
                    TextFieldCustom(text: $viewModel.confirmPassword,
                                    placeholder: Text("Confirm password").foregroundColor(.gray),
                                    isSecureField: true)
                    
                    Button(action: {
                        handleCheckEmail()
                    }, label: {
                        Text("Continue...")
                            .bold(size: 18)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .foregroundColor(Color.white.opacity(viewModel.invalidInfo ? 0.5: 1))
                            .background(Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.337254902, alpha: 1)).opacity(viewModel.invalidInfo ? 0.5: 1))
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 40)
                    .foregroundColor(.white)
                    .disabled(viewModel.invalidInfo)
                }
                .padding(.horizontal)
                .padding(.top, Constants.MARGIN_WITH_BACK_BAR)
            }
            .padding(.top, Constants.MARGIN_TOP_STATUS_BAR)
        }
        .addBackBarCustom(.black)
        .handleErrors($viewModel.error)
        .addLoadingIcon($viewModel.isLoading)
        .statusBarStyle(.darkContent)
        .foregroundColor(Color.black)
        .handleHidenKeyboard()
    }
}

extension ForgotPasswordView {
    private func handleCheckEmail() {
        hideKeyboard()
        viewModel.handleCheckEmail()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ForgotPasswordView()
        }
    }
}

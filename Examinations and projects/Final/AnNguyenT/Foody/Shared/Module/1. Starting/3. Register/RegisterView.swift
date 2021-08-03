//
//  RegisterView.swift
//  Foody
//
//  Created by An Nguyễn on 2/28/21.
//

import SwiftUI
import SwiftUIX
import PhoneNumberKit

struct MultilineTextView: UIViewRepresentable {

    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    var textColor: UIColor = .white

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.textColor = textColor
        textView.backgroundColor = .clear
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    func makeCoordinator() -> Coodinator {
        Coodinator(self)
    }
    
    class Coodinator: NSObject, UITextViewDelegate {
        var textView: MultilineTextView
        
        init(_ textView: MultilineTextView) {
            self.textView = textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.textView.text = textView.text
        }
    }
}

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            Image("bg_login")
                .resizable()
                .ignoresSafeArea()
            
            NavigationLink(destination: VerifyPhoneView(viewModel: viewModel.verifyPhoneViewModel),
                           isActive: $viewModel.emailExist, label: { EmptyView() })
            
            ScrollView {
                VStack(alignment: .leading) {
                    Section {
                        Text("Register")
                            .bold(size: 44)
                        Text("Please enter details to register.")
                            .regular(size: 18)
                            .padding(.bottom, 30)
                    }
                    
                    Section(header: Text("")) {
                        Toggle("Join with restaurant:", isOn: $viewModel.isRestaurant)
                            .bold(size: 17)
                    }
                    
                    Section(header: Text(""), footer: Text("")) {
                        TextFieldCustom(text: $viewModel.userInfo.username,
                                        placeholder: Text("Username").foregroundColor(.gray),
                                        systemNameImage: "person"
                        )
                        
                        if viewModel.isRestaurant {
                            TextFieldCustom(text: $viewModel.userInfo.restaurantName,
                                            placeholder: Text("Restaurant name").foregroundColor(.gray),
                                            systemNameImage: "house"
                            )
                            
                            ZStack(alignment: .topLeading) {
                                Text("Descriptions...")
                                    .foregroundColor(.gray)
                                    .hidden(!viewModel.userInfo.description.isEmpty)
                                    .padding(.top, 10)
                                    .padding(.leading, 2)
                                
                                MultilineTextView(text: $viewModel.userInfo.description, textStyle: .constant(.body))
                                    .frame(minHeight: 100, maxHeight: 150)
                            }
                            .padding()
                            .border(cornerRadius: 5)
                        }
                    }
                    
                    Section(header: Text(""), footer: Text("")) {
                        HStack(spacing: 10) {
                            Text("Gender")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .padding(.trailing, 5)
                            
                            Spacer()
                            
                            RadioButton(isSelected: $viewModel.isMale,
                                        action: {
                                            viewModel.isMale = true
                            }, content: { Text("Male") })
                            
                            RadioButton(isSelected: .constant(!viewModel.isMale),
                                        action: {
                                            viewModel.isMale = false
                            }, content: { Text("Female") })
                                .padding(.trailing, 10)
                            }
                    }
                    .animation(.easeInOut(duration: 0.3))
                    
                    Section(header: Text(""), footer: Text("")) {
                        TextFieldCustom(text: $viewModel.userInfo.email,
                                        placeholder: Text("Email").foregroundColor(.gray)
                        )
                        
                        ZStack(alignment: .leading) {
                            Text(PartialFormatter().formatPartial("+84399879847"))
                                .foregroundColor(.gray)
                                .padding(.leading, 29)
                                .hidden(!viewModel.userInfo.phoneNumber.isEmpty)
                            
                            PhoneNumberTextView(phoneNumber: $viewModel.userInfo.phoneNumber)
                        }
                    }
                    
                    Section(header: Text(""), footer: Text("")) {
                        TextFieldCustom(text: $viewModel.userInfo.password,
                                        placeholder: Text("Password").foregroundColor(.gray),
                                        isSecureField: true
                        )
                        
                        TextFieldCustom(text: $viewModel.userInfo.verifyPassword,
                                        placeholder: Text("Confirm password").foregroundColor(.gray),
                                        isSecureField: true
                        )
                    }
                    
                    Section(header: Text(""), footer: Text("")) {
                        Button(action: {
                            viewModel.checkEmail()
                        }, label: {
                            Text("Register")
                                .bold(size: 18)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.337254902, alpha: 1)).opacity(viewModel.inValidInfo ? 0.5: 0.7))
                                .foregroundColor(Color.white.opacity(viewModel.inValidInfo ? 0.5: 1))
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 30)
                        .disabled(viewModel.inValidInfo)
                    }
                    
                    Section(header: Text(""), footer: Text("")) {
                        HStack {
                            Text("Already have an account?")
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Login")
                                    .underline()
                                    .bold(size: 17)
                            })
                        }
                        .padding(.top, Constants.MARGIN_WITH_BACK_BAR)
                        .frame(maxWidth: .infinity)
                    }
                }
                .animation(.default)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, Constants.MARGIN_WITH_BACK_BAR)
            }
            .padding(.top, Constants.MARGIN_TOP_STATUS_BAR)
        }
        .addBackBarCustom(.white)
        .handleErrors($viewModel.error)
        .addLoadingIcon($viewModel.isLoading)
        .handleHidenKeyboard()
        .statusBarStyle(.lightContent)
        .font(.body)
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterView()
        }
    }
}

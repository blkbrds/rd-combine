//
//  UpdateInfoVIew.swift
//  Foody
//
//  Created by MBA0283F on 5/10/21.
//

import SwiftUI
import SwiftUIX

struct UpdateInfoView: View {
    @StateObject private var viewModel = UpdateInfoViewModel()
    @State private var isPresentedPickerView = false
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ZStack {
                    Image(viewModel.images.first?.pngData(), isProfile: true)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                    
                    Image(systemName: SFSymbols.cameraFill)
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 20)
                }
                .onTapGesture {
                    isPresentedPickerView = true
                }
                .padding(.top, 30)
                .padding(.bottom, 10)
                
                TextField("Username...", text: $viewModel.username)
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .padding(.horizontal)
                    .border(cornerRadius: 23)
                
                TextField("Address...", text: $viewModel.address)
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .padding(.horizontal)
                    .border(cornerRadius: 46 / 2)
                
                TextField("Age...", text: $viewModel.age)
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .padding(.horizontal)
                    .border(cornerRadius: 46 / 2)
                    .keyboardType(.numberPad)
                
                if isResraurant {
                    TextView("Description...", text: $viewModel.description)
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .padding()
                        .border(cornerRadius: 15)
                }
                
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
                .animation(.easeInOut(duration: 0.3))
                
                Button(action: {
                    viewModel.updateProfile()
                }, label: {
                    Text("Update")
                        .bold(size: 18)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.337254902, alpha: 1)).opacity(viewModel.inValidInfo ? 0.5: 0.9))
                        .foregroundColor(Color.white.opacity(viewModel.inValidInfo ? 0.5: 1))
                })
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.vertical, 30)
                .disabled(viewModel.inValidInfo)
            }
            .fullScreenCover(isPresented: $isPresentedPickerView, content: {
                ImagePickerView($viewModel.images, isUpdatingInfo: true)
                    .ignoresSafeArea()
            })
            .padding()
        }
        .onReceive(viewModel.$isUpdated, perform: { isUpdated in
            if isUpdated {
                handleShowNotiPupup()
            }
        })
        .navigationBarTitle("Update Profile", displayMode: .inline)
        .setupNavigationBar()
        .navigationBarBackButton()
        .addLoadingIcon($viewModel.isLoading)
        .handleErrors($viewModel.error)
        .handleHidenKeyboard()
    }
}

extension UpdateInfoView {
    func handleShowNotiPupup() {
        presentView(
            AlertView(
                .constant(PopupContent(message: "Profile update successful.", title: "Success"))
            )
            .onDisappear(perform: {
                presentationMode.wrappedValue.dismiss()
            })
        )
    }
}

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInfoView()
    }
}

//
//  FoodDetailsView.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

protocol Navigation {
    var isActive: Binding<Bool> { get set }
    var isRootActive: Binding<Bool>? { get set }
}

struct FoodDetailsView: View, Navigation {
    var isActive: Binding<Bool>
    var isRootActive: Binding<Bool>?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.navibarColor
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Go back!")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
//                        isActive.wrappedValue.toggle()
                    }
                Text("Pop to root!")
                    .onTapGesture {
                        // Open from trending view
                        if let _ = isRootActive {
                            isRootActive?.wrappedValue = false
                        } else {
                            isActive.wrappedValue = false
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
        .navigationTitle(Text("Food Details"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold, design: .default))
                                })
        )
    }
}

//struct FoodDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailsView()
//    }
//}

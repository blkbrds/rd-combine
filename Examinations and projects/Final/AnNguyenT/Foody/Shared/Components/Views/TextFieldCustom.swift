//
//  TextFieldCustom.swift
//  Foody
//
//  Created by An Nguyễn on 2/24/21.
//

import SwiftUI

struct TextFieldCustom: View {
    @Binding var text: String
    var placeholder: Text
    var onCommit: (() -> Void)?
    var isSecureField: Bool = false
    @State private var showPass = false
    var systemNameImage: String = "envelope"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: isSecureField ? 4: 2) {
                    if isSecureField {
                        Image("padlock-icon")
                            .resizable()
                            .frame(width: 18, height: 23)
                    } else {
                        Image(systemName: systemNameImage)
                    }
                    //Text(":")
                }
                
                ZStack(alignment: .leading) {
                    if text.isEmpty { placeholder }
                    HStack {
                        if !isSecureField || showPass {
                            TextField("", text: $text, onCommit: {
                                onCommit?()
                            })
                        } else {
                            SecureField("", text: $text, onCommit: {
                                onCommit?()
                            })
                        }
                        if isSecureField {
                            Button(action: {
                                showPass.toggle()
                            }, label: {
                                Image(systemName: showPass ? "eye.fill": "eye.slash.fill")
                            })
                        } else {
                            if !text.isEmpty {
                                Button(action: {
                                    text = ""
                                }, label: {
                                    Image(systemName: "multiply.circle.fill")
                                })
                            }
                        }
                    }
                    .frame(height: 45)
                }
            }
            
            Divider()
                .background(Color.white)

        }
    }
}

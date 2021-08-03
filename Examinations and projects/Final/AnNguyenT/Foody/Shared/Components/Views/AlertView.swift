//
//  AlertView.swift
//  Foody
//
//  Created by MBA0283F on 4/23/21.
//

import SwiftUI

struct AlertView<Item>: View where Item: Identifiable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var item: Item?
    @AppStorage("AppState") private var state: AppState = .login
    
    init(_ item: Binding<Item?> = .constant(nil)) {
        _item = item
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text(type.title)
                    .bold(size: 27)
                
                Text(message)
                    .regular(size: 17)
                    .padding(.horizontal, 15)
                
                Button(action: {
                    if let error = item as? CommonError, error == .isBlocked {
                        if let url = URL(string: ProfileView.Config.helpUrl), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:])
                        }
                        return
                    }
                    presentationMode.wrappedValue.dismiss()
                    dismiss()
                    (item as? PopupContent)?.action?()
                    if let error = item as? CommonError, error == .expiredToken {
                        state = .login
                    }
                }, label: {
                    Text(buttonTitle)
                        .bold(size: 17)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(type.color)
                })
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            .multilineTextAlignment(.center)
            .foregroundColor(Color.black)
            .padding([.horizontal, .vertical], 20)
            .padding(.top, 40 * scale)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            
            let width = 70 * scale
            Circle()
                .strokeBorder(Color.white, lineWidth: 5)
                .frame(width: width, height: width)
                .background(
                    ZStack {
                        Circle().fill(type.color)

                        Image(systemName: type.systemImage)
                            .font(.system(size: 30, weight: .bold, design: .default))
                    }
                    .foregroundColor(Color.white)
                )
                .offset(x: 0, y: -width / 2)
                .shadow(color: Color.gray, radius: 2, x: 0, y: 0)
        }
        .padding(.horizontal, 30)
        .onDisappear(perform: {
            item = nil
        })
        .shadow(color: .gray, radius: 2, x: -2, y: 2)
    }
}

extension AlertView {
    enum AlertType {
        case error, normal, isBlocked
        
        var color: Color {
            self == .error || self == .isBlocked ? Color(#colorLiteral(red: 0.7568627451, green: 0.1725490196, blue: 0.1764705882, alpha: 1)): .green
        }
        
        var systemImage: String {
            self == .error || self == .isBlocked ? "xmark": "checkmark"
        }
        
        var title: String {
            self == .error || self == .isBlocked ? "Error": "Success"
        }
        
        var buttonTitle: String {
            switch self {
            case .error:
                return "Close"
            case .normal:
                return "OK"
            default:
                return "Call"
            }
        }
    }
    
    var buttonTitle: String {
        if let content = item as? PopupContent {
            return content.title
        }
        return type.buttonTitle
    }
    
    var message: String {
        if let error = item as? CommonError {
            return error.description
        } else if let content = item as? PopupContent {
            return content.message
        }
        return ""
    }
    
    var type: AlertType {
        if let error = item as? CommonError {
            return error == .isBlocked ? .isBlocked: .error
        }
        return .normal
    }
    
    var scale: CGFloat {
        kScreenSize.width / 375
    }
}

struct PopupContent: Identifiable {
    var id: String = UUID.init().uuidString
    var message: String
    var title: String = ""
    var action: (() -> Void)?
}

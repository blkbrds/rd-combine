//
//  NotificationsView.swift
//  Foody
//
//  Created by An Nguyễn on 04/05/2021.
//

import SwiftUI

struct NotificationView: View {
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            ZStack {
                Image(systemName: SFSymbols.bellFill)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.blue)
                    .offset(x: 6, y: -6)
                    .opacity(Session.shared.haveNotifications ? 1: 0)
            }
            .shadow(color: .white, radius: 10, x: 0.0, y: 0.0)
        })

    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

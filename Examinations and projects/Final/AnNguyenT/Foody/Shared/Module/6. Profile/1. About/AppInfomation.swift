//
//  AppInfomation.swift
//  Foody
//
//  Created by MBA0283F on 5/28/21.
//

import SwiftUI

struct AppInfomation: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .frame(width: 60, height: 60)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                .padding(.bottom)
            
            Text("Version: 1.0.0")
            
            Spacer()
        }
        .addBackBarCustom()
        .statusBarStyle(.darkContent)
        .statusBar(hidden: false)
    }
}

struct AppInfomation_Previews: PreviewProvider {
    static var previews: some View {
        AppInfomation()
    }
}

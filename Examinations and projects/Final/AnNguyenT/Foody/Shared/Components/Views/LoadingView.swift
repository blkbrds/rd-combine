//
//  LoadingView.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI

struct LoadingView<Presenting>: View where Presenting: View {
    
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool {
        didSet {
            timeRemaining = 1.5
            isLoading = isShowing
        }
    }
    /// The view that will be "presenting" this LoadingView
    let presenting: () -> Presenting
    /// Finish showing
    var completion: (() -> Void)?

    @State private var isLoading = false
    @State private var timeRemaining = 1.5
    var timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                
                if isShowing {
                    Circle()
                        .trim(from: 0, to: 0.6)
                        .stroke(Color.Token.toast.text, lineWidth: 5)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .onAppear { self.isLoading = true }
                        .onDisappear { self.isLoading = false }
                        
                        .frame(width: geometry.size.width / 6,
                               height: geometry.size.width / 6)
                        .padding(15)
                        .background(Color.Token.toast.background.opacity(0.6))
                        .cornerRadius(10)
                        .transition(.scale)
                        .onReceive(timer) { time in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 0.5
                            } else {
                                isShowing = false
                                completion?()
                            }
                        }
                }
            }
        }
    }
}

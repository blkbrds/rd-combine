//
//  ToastView.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI

struct ToastView<Presenting>: View where Presenting: View {
    
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool {
        didSet {
            timeRemaining = 1.5
        }
    }
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    let text: Text
    /// Finish showing
    var completion: (() -> Void)?
    
    @State private var timeRemaining = 1.5
    var timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                
                if isShowing {
                    text
                        .frame(width: geometry.size.width / 2)
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .background(Color.Token.toast.background.opacity(0.6))
                        .foregroundColor(Color.Token.toast.text)
                        .cornerRadius(10)
                        .transition(.slide)
                        .myFont(.toast)
                        .lineSpacing(5)
                        .onReceive(timer) { time in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 0.5
                            } else {
                                completion?()
                                isShowing = false
                            }
                        }
                }
            }
        }
    }
}

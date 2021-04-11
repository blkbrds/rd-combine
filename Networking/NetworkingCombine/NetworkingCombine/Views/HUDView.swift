//
//  HUDView.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/9/21.
//

import SwiftUI

struct HUDCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: .init(x: rect.midX, y: rect.midY), radius: 50 / 2,
                    startAngle: .init(degrees: 90), endAngle: .init(degrees: 0), clockwise: false)
        
        return path
    }
}

struct HUDView: View {
    @State private var angle: Angle = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 85, height: 85)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0.0, y: 0.0)
            
            HUDCircle()
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .leading, endPoint: .trailing),
                    lineWidth: 5
                )
                .shadow(color: Color.red.opacity(0.2), radius: 5, x: 0, y: 0)
                .rotationEffect(angle)
                .animation(.easeIn(duration: 0.4))
                .onAppear(perform: {
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (_) in
                        angle.degrees += 360
                    }
                })
        }
        
    }
}

struct HUDView_Previews: PreviewProvider {
    static var previews: some View {
        HUDView()
    }
}

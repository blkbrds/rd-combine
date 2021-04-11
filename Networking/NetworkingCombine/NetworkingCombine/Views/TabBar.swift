//
//  TabBarView.swift
//  List-Navigation Demo
//
//  Created by MBA0283F on 3/5/21.
//

import SwiftUI

enum TabItems: Int {
    case home, discover, cart, favorites, profile

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .discover:
            return "Discover"
        case .cart:
            return ""
        case .favorites:
            return "Favorites"
        default:
            return "Profile"
        }
    }

    var imageName: String {
        switch self {
        case .home:
            return "home_icon"
        case .discover:
            return "discover_icon"
        case .cart:
            return "cart_icon"
        case .favorites:
            return "favorites_icon"
        default:
            return "profile_icon"
        }
    }
}

struct TabBar: View {
    @Binding var currentIndex: Int
    var items: [TabItems] = [.home, .discover, .cart, .favorites, .profile]
    @State private var isClicking: Bool = false

    var body: some View {
        ZStack {
            RoundedTabCenter()
                .shadow(color: .gray, radius: 5, x: 0.0, y: 0.0)
                .foregroundColor(.white)
            
            HStack {
                ForEach(items, id: \.self) { item in
                    VStack {
                        if item == .cart {
                            ZStack {
                                Circle()
                                    .frame(width: 63, height: 63)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 7)

                                    )
                                    .blur(radius: 0.1)
                                    .shadow(color: .gray, radius: 4, x: 0.0, y: 0)
                                    .foregroundColor(Colors.redPrimary.opacity(currentIndex == item.rawValue ? 1: 0.7))
                                
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .padding(.bottom, 50)
                            .foregroundColor(.white)
                        } else {
                            TabItem(item: item, currentIndex: $currentIndex)
                                .frame(width: UIScreen.main.bounds.width / 5.5)
                        }

                    }
                    .scaleEffect(isClicking && currentIndex == item.rawValue ? 1.1: 1)
                    .animation(.interpolatingSpring(mass: 0.5, stiffness: 400, damping: 5, initialVelocity: 1))
                    .onTapGesture {
                        currentIndex = item.rawValue
                        isClicking = true
                        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
                            isClicking = false
                        }
                    }

                    if item != .profile {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 25)
        }
    }
}

struct TabItem: View {
    var item: TabItems
    @Binding var currentIndex: Int

    var body: some View {
        VStack(spacing: 5) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
            Text(item.title)
                .font(.system(size: 12, weight: .bold, design: .default))
        }
        .foregroundColor(currentIndex == item.rawValue ? Colors.redPrimary : Colors.lightGray)
    }
}

//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}

struct RoundedTabCenter: Shape {
    func path(in rect: CGRect) -> Path {
        let tabCenter: CGFloat = rect.midX
        
        let controlRatio: CGPoint = .init(x: 45, y: 20)

        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        p.addLine(to: CGPoint(x: tabCenter + 140, y: rect.minY))

        p.addCurve(to: CGPoint(x: tabCenter, y: rect.midY - 76),
                   control1: CGPoint(x: tabCenter + controlRatio.x, y: rect.minY),
                   control2: CGPoint(x: tabCenter + controlRatio.x, y: rect.minY - controlRatio.y))

        p.addCurve(to: CGPoint(x: tabCenter - 140, y: rect.minY),
                   control1: CGPoint(x: tabCenter - controlRatio.x, y: rect.minY - controlRatio.y),
                   control2: CGPoint(x: tabCenter - controlRatio.x, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return p
    }
}

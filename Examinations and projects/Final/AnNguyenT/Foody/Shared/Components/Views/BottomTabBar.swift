//
//  TabBarView.swift
//  Foody
//
//  Created by MBA0283F on 3/3/21.
//

import SwiftUI
import UIKit
import SwiftUIX

enum TabItem: CaseIterable {
    case home, search, carts, likes, profile, orders, charts
    
    var id: UUID { return UUID() }
    
    var index: Int {
        switch self {
        case .home:
            return 0
        case .search, .orders, .carts:
            return 1
        case .likes, .charts:
            return 2
        case .profile:
            return 3
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .carts:
            return "Carts"
        case .likes:
            return "Likes"
        case .search:
            return "Search"
        case .orders:
            return "Orders"
        case .charts:
            return "Charts"
        default:
            return "Profile"
        }
    }
    
    var imageName: SFSymbolName {
        switch self {
        case .home:
            return SFSymbolName.houseFill
        case .carts:
            return SFSymbolName.cart
        case .likes:
            return SFSymbolName.heartFill
        case .search:
            return SFSymbolName.magnifyingglass
        case .orders:
            return SFSymbolName.docFill
        case .charts:
            return SFSymbolName.flameFill
        default:
            return SFSymbolName.personFill
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .purple
        case .profile:
            return .blue
        case .likes, .charts:
            return .pink
        case .search, .orders, .carts:
            return .orange
        }
    }
}

struct BottomTabBar: View {
    var tabItems: [TabItem]
    @Binding var indexSelected: Int
    
    var body: some View {
        VStack {
            Divider()
            HStack(spacing: 30) {
                Spacer()
                
                ForEach(tabItems, id: \.id) { item in
                    TabBarItem(item: item, indexSelected: $indexSelected)
                }
                
                Spacer()
            }
        }
    }
}

struct TabBarItem: View {
    var item: TabItem
    @Binding var indexSelected: Int
    @State private var isClicking: Bool = false
    private var isSelected: Bool {
        item.index == indexSelected
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: item.imageName)
                .resizable()
                .systemBold(size: 5)
                .frame(width: 17, height: 17)
            Text(isSelected ? item.title: "")
                .systemBold(size: 12)
                .padding(.leading, isSelected ? 5: 0)
        }
        .frame(width: isSelected ? 90: 30)
        .padding(.horizontal, isSelected ? 15: 5)
        .padding(.vertical, 10)
        .scaleEffect(isClicking ? 1.2: isSelected ? 1.1: 1)
        .animation(.interpolatingSpring(mass: 1.0, stiffness: 500,
                                        damping: 14, initialVelocity: 0.2))
       
        .foregroundColor(isSelected ? item.color: Color.gray)
        .background(isSelected ? item.color.opacity(0.3): Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .animation(.interpolatingSpring(mass: 1.0, stiffness: 200,
                                        damping: 20, initialVelocity: 0.1))
        .onTapGesture(count: 2) {
            print("DEBUG - Double tappp...")
            NotificationCenter.default.post(name: .refreshTab, object: item.index)
        }
        .onTapGesture {
            print("DEBUG - Tappp...")
            indexSelected = item.index
            Session.shared.currentTab = indexSelected
            NotificationCenter.default.post(name: .didSelectedTab, object: indexSelected)
            isClicking = true
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (_) in
                isClicking = false
            }
        }
    }
}

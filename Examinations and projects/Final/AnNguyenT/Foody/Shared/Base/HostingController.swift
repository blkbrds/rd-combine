//
//  HostingController.swift
//  Foody
//
//  Created by An Nguyễn on 4/5/21.
//

import SwiftUI

final class HostingController<ContentView>: UIHostingController<ContentView> where ContentView: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.statusBarStyle
    }
}

extension View {
    ///Sets the status bar style color for this view.
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        UIApplication.statusBarStyleHierarchy.append(style)
        //Once this view appears, set the style to the new style. Once it disappears, set it to the previous style.
        return self.onAppear {
            UIApplication.setStatusBarStyle(style)
        }.onDisappear {
            guard UIApplication.statusBarStyleHierarchy.count > 1 else { return }
            let style = UIApplication.statusBarStyleHierarchy[UIApplication.statusBarStyleHierarchy.count - 1]
            UIApplication.statusBarStyleHierarchy.removeLast()
            UIApplication.setStatusBarStyle(style)
        }
    }
}

extension UIApplication {
    static var hostingController: HostingController<AnyView>? = nil
    
    static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
    static var statusBarStyle: UIStatusBarStyle = .darkContent
    
    static func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        hostingController?.setNeedsStatusBarAppearanceUpdate()
    }
}

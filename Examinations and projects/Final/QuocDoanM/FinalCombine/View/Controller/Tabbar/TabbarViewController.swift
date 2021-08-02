//
//  TabbarViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/15/21.
//

import UIKit
import Combine

final class TabbarViewController: UITabBarController {

    private var customTabBar: TabbarCustom!
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTabbar()
    }

    private func loadTabbar() {
        let tabbarItems: [TabbarItem] = TabbarItem.allCases.map { (TabbarItem(rawValue: $0.rawValue) ?? .top) }
        setupCustomTabMenu(tabbarItems) { controllers in
            self.viewControllers = controllers
        }
        selectedIndex = 0
    }

    private func setupCustomTabMenu(_ menuItems: [TabbarItem], completion: @escaping ([UINavigationController]) -> Void) {
        let frame = tabBar.frame
        var naviControllers = [UINavigationController]()
        tabBar.isHidden = true
        customTabBar = TabbarCustom(menuItems: menuItems, frame: frame)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.clipsToBounds = true
        customTabBar.subject
            .sink { [weak self] tab in
                guard let this = self else { return }
                this.changeTab(tab: tab)
            }
            .store(in: &cancellables)
        view.addSubview(customTabBar)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: Define.heightTabbar),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        menuItems.forEach { naviControllers.append($0.naviControllers) }
        
        view.layoutIfNeeded()
        completion(naviControllers)
    }

    private func changeTab(tab: Int) {
        selectedIndex = tab
    }
}

extension TabbarViewController {
    private struct Define {
        static let heightTabbar: CGFloat = 67
    }
}

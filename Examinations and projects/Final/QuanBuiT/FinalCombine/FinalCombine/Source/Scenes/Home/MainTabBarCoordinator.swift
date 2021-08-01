//
//  MainTabBarCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Combine

final class MainTabBarCoordinator: TabBarCoordinator {
    enum Tab {
        case postList
        case search
    }

    override func start() {
        [.postList, .search].forEach(createTab)
        let viewControllers = childCoordinators.compactMap {
            $0.viewController
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }

    func createTab(_ tab: Tab) {
        switch tab {
        case .postList:
            let coordinator = ToDoListCoordinator()
            addChild(coordinator)
            coordinator.start()
            coordinator.viewController.tabBarItem = tab.tabBarItem
        case .search:
            let coordinator = SearchCoordinator()
            addChild(coordinator)
            coordinator.start()
            coordinator.viewController.tabBarItem = tab.tabBarItem
        }
    }
}

extension MainTabBarCoordinator.Tab {

    var tabBarItem: UITabBarItem {
        switch self {
        case .postList:
            return UITabBarItem(title: "Posts", systemName: "rectangle.grid.2x2.fill", tag: 0)
        case .search:
            return UITabBarItem(title: "Search", systemName: "magnifyingglass", tag: 1)
        }
    }
}

private extension UITabBarItem {
    convenience init(title: String, systemName: String, tag: Int) {
        self.init(
            title: title,
            image: UIImage(
                systemName: systemName,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 20,
                    weight: .medium
                )
            )!,
            tag: tag
        )
    }
}

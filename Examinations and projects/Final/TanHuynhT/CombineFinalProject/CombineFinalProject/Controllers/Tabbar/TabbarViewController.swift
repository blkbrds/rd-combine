//
//  TabbarViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }

    private func configTabbar() {
        //Home
        let homeVC = HomeViewController()
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: ""), tag: 0)

        //Search
        let searchVC = SearchViewController()
        let searchNavi = UINavigationController(rootViewController: searchVC)
        searchNavi.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: ""), tag: 1)

        //Subcriptions
        let subsVC = SubscriptionViewController()
        let subsNavi = UINavigationController(rootViewController: subsVC)
        subsNavi.tabBarItem = UITabBarItem(title: "Subscriptions", image: UIImage(named: ""), tag: 2)

        //Profile
        let profileVC = ProfileViewController()
        let profileNavi = UINavigationController(rootViewController: profileVC)
        profileNavi.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: ""), tag: 3)

        viewControllers = [homeNavi, searchNavi, subsNavi, profileNavi]
    }

    func switchItem(item: TabItem) {
        selectedIndex = item.rawValue
    }
}

extension TabBarViewController {

    enum TabItem: Int {
        case home
        case search
        case profile
    }
}

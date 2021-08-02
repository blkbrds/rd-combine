//
//  TabBarVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 8/2/21.
//

import UIKit

final class TabBarVC: UITabBarController {

    let homeVC = HomeVC()
    let profileVC = ProfileVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }


    // MARK: - Navigation
    private func configTabbar() {
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "list.dash"), tag: 0)
        homeVC.viewModel = HomeViewModel()

        let profileNavi = UINavigationController(rootViewController: profileVC)
        profileNavi.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        tabBar.tintColor = .orange
        delegate = self
        viewControllers = [homeNavi, profileNavi]
    }
}

extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected Tab : \(tabBarController.selectedIndex)")
    }
}

//
//  TabBarController.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 8/2/21.
//

import UIKit
import SwifterSwift

class TabBarController: UITabBarController {

    enum TabbarType: Int {
        case home, category, profile
    }

    // MARK: - Properties
    var selectedTab: TabbarType = .home {
        didSet {
            selectedIndex = selectedTab.rawValue
        }
    }

    override var selectedIndex: Int {
        didSet {
            viewControllers?.forEach {
                $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 10)], for: .normal)
            }
            guard let selectedVC = viewControllers?[selectedIndex] else { return }
            selectedVC.tabBarItem.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0, green: 0.2552632093, blue: 0.4001309276, alpha: 1), .font: UIFont.systemFont(ofSize: 10)], for: .normal)
        }
    }

    override var selectedViewController: UIViewController? {
        didSet {
            guard let viewControllers = viewControllers else { return }
            for vc in viewControllers {
                if vc == selectedViewController {
                    vc.tabBarItem.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0, green: 0.2552632093, blue: 0.4001309276, alpha: 1), .font: UIFont.systemFont(ofSize: 10)], for: .normal)
                } else {
                    vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 10)], for: .normal)
                }
            }
        }
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        modalPresentationStyle = .overFullScreen
        tabBar.borderWidth = 0.5
        tabBar.borderColor = UIColor.gray.withAlphaComponent(0.3)
        tabBar.clipsToBounds = true
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        for vc in viewControllers.unwrapped(or: []) {
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: -4.5, left: 0, bottom: 4.5, right: 0)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: Extension UITabBar
extension UITabBar {

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
         var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = Measurement.tabBarHeight
         return sizeThatFits
     }
}

// MARK: Instance

extension TabBarController {

    static func defaultTabbar(tabType: TabBarController.TabbarType) -> TabBarController {
        let tabBarController = TabBarController()
        let homeVC = HomeViewController()
        let categoryVC = MovieCategoryViewController()
        let profileVC = ProfileViewController()
        let homeImage = #imageLiteral(resourceName: "home_icon")
        let categoryImage = #imageLiteral(resourceName: "category_icon")
        let profileImage = #imageLiteral(resourceName: "profile_icon")


        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: homeImage.withRenderingMode(.alwaysOriginal),
                                         selectedImage: homeImage)
        categoryVC.tabBarItem = UITabBarItem(title: "Category",
                                           image: categoryImage.withRenderingMode(.alwaysOriginal),
                                           selectedImage: categoryImage)
        profileVC.tabBarItem = UITabBarItem(title: "Profile",
                                             image: profileImage.withRenderingMode(.alwaysOriginal),
                                             selectedImage: profileImage)

        tabBarController.tabBar.setColors(background: .white, selectedBackground: .white, item: nil, selectedItem: #colorLiteral(red: 0, green: 0.2552632093, blue: 0.4001309276, alpha: 1))
        let controllers: [UIViewController] = [homeVC, categoryVC, profileVC]
        tabBarController.viewControllers = controllers.map {
            return NavigationController(rootViewController: $0)
        }
        tabBarController.selectedTab = tabType

        return tabBarController
    }
}


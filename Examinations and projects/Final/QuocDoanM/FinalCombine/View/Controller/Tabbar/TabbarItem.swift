//
//  TabbarItem.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/15/21.
//

import UIKit

enum TabbarItem: String, CaseIterable {
//    case profile = "PROFILE"
    case top = "TOP"
    case searchList = "SEARCH GAME"
    case profile = "PROFILE"

    var naviControllers: UINavigationController {
        switch self {
        case .top:
            return UINavigationController(rootViewController: TopViewController())
        case .searchList:
            return UINavigationController(rootViewController: SearchViewController())
        case .profile:
            return UINavigationController(rootViewController: ProfileViewController())
        }
    }

    var icon: UIImage {
        switch self {
        case .top:
            return #imageLiteral(resourceName: "ic_top")
        case .searchList:
            return #imageLiteral(resourceName: "ic_search_list")
        case .profile:
            return #imageLiteral(resourceName: "ic_profile")
        }
    }

    var title: String {
        return self.rawValue.capitalized(with: nil)
    }
}

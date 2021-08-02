//
//  MainTabBarController.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .blue
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .black
        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        }
    }
}

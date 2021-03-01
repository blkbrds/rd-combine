//
//  AppDelegate.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/18/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()
        return true
    }
}


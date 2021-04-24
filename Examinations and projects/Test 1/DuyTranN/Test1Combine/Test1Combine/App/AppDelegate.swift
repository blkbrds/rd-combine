//
//  AppDelegate.swift
//  Test1Combine
//
//  Created by Duy Tran N. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        if let window = window {
            window.makeKeyAndVisible()
            window.backgroundColor = .darkGray
            window.rootViewController = HomeViewController()
        }

        return true
    }
}

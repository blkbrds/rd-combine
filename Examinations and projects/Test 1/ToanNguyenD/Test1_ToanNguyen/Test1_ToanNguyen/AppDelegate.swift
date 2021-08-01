//
//  AppDelegate.swift
//  Test1_ToanNguyen
//
//  Created by Toan Nguyen D. [4] on 2/26/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeViewController()
        window?.backgroundColor = .white
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}


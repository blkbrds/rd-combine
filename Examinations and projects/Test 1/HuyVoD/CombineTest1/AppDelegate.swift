//
//  AppDelegate.swift
//  CombineTest1
//
//  Created by MBA0288F on 2/25/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = ContentVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

}


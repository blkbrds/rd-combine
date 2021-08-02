//
//  AppDelegate.swift
//  TheMovieCombineApp
//
//  Created by Hoa Nguyen X. [2] VN.Danang on 27/07/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum RootType {
        case loginVC
        case home
    }

    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return shared
    }()
    var window: UIWindow?
    let login: UIViewController = LoginViewController()
    let navi = UINavigationController(rootViewController: HomeViewController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .blue
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func changeRoot(rootType: RootType) {
        switch rootType {
        case .loginVC:
            window?.rootViewController = login
        default:
            window?.rootViewController = navi
        }
    }
}


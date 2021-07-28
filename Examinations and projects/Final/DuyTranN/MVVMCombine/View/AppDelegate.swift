//
//  AppDelegate.swift
//  MVVMCombine
//
//  Created by Khoa Vo T.A. VN.Danang on 6/9/21.
//

import UIKit
import IQKeyboardManagerSwift

let userDefaults = UserDefaults.standard
let notificationCenter = NotificationCenter.default
let iqKeyboard = IQKeyboardManager.shared

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
        }
        return shared
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configRoot()
        configIQKeyBoardManager()
        return true
    }
}

// MARK: - Extension AppDelegate
extension AppDelegate {

    enum RootType {
        case listNews
    }

    // MARK: - Public functions
    func changeRoot(to root: RootType) {
        switch root {
        case .listNews:
            let vc = NewsViewController()
            window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }

    // MARK: - Private functions
    private func configRoot() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
//        window?.rootViewController = SignInViewController()
        window?.rootViewController = UINavigationController(rootViewController: NewsViewController())
    }

    private func configIQKeyBoardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}

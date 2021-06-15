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
        configIQKeyBoardManager()
        return true
    }

    private func configIQKeyBoardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}

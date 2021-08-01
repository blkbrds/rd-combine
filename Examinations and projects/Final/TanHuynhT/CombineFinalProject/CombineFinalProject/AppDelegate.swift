//
//  AppDelegate.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/17/21.
//

import UIKit
import SVProgressHUD
import SwiftUtils
import Firebase
import AVFoundation

typealias hud = SVProgressHUD

let userDefaults = UserDefaults.standard
let notificationCenter = NotificationCenter.default

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum Root {
        case home
        case login
    }

    var window: UIWindow?
    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
        }
        return shared
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configAudio()
        let vc = LoginViewController()
        let navi = UINavigationController(rootViewController: vc)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }

    private func configAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }

    func setRootViewController(root: Root) {
        let tabbarVC = TabBarViewController()
        window?.rootViewController = tabbarVC
        switch root {
        case .home:
            let tabbarVC = TabBarViewController()
            window?.rootViewController = tabbarVC
        case .login:
            let loginViewController = LoginViewController()
            window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        }
    }
}

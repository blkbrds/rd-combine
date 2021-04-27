//
//  SceneDelegate.swift
//  CombineTest1
//
//  Created by Tran Van Tien on R 3/02/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let homeVC = HomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()
    }
}

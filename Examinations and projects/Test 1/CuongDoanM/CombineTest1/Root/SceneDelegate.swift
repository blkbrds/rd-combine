//
//  SceneDelegate.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/26/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene: UIWindowScene = (scene as? UIWindowScene) else { return }
        let window: UIWindow = UIWindow(windowScene: scene)
        window.rootViewController = HomeViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

//
//  SceneDelegate.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let vc = SignInViewController()
        window.rootViewController = UINavigationController(rootViewController: vc)
        self.window = window
        window.makeKeyAndVisible()
    }
}


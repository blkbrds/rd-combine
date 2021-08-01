//
//  SceneDelegate.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/18/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.rootViewController = HomeViewController()
        window.makeKeyAndVisible()
    }
}

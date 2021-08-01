//
//  SceneDelegate.swift
//  Test1
//
//  Created by MBA0225 on 3/1/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navi = UINavigationController(rootViewController: HomeViewController())
        window.rootViewController = navi
        self.window = window
        window.makeKeyAndVisible()
    }
}

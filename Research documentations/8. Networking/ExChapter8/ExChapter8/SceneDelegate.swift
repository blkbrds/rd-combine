//
//  SceneDelegate.swift
//  ExChapter8
//
//  Created by MBA0225 on 4/4/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = ViewController()
                self.window = window
                window.makeKeyAndVisible()
    }
}

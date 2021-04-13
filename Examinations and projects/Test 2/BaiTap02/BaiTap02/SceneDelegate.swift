//
//  SceneDelegate.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/13/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let vc = SignInViewController()
        //vc.viewModel = SignInViewModel()
        window.rootViewController = UINavigationController(rootViewController: vc)
        self.window = window
        window.makeKeyAndVisible()
    }
}


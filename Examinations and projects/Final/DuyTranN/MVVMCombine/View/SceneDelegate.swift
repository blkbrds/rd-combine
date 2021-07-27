//
//  SceneDelegate.swift
//  MVVMCombine
//
//  Created by Khoa Vo T.A. VN.Danang on 6/9/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    enum RootType {
    }

    static var shared: SceneDelegate {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Can not case scene delegate")
        }
        return scene
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScence)
        UIButton.appearance().isExclusiveTouch = true
        configWindow()
    }

    func configWindow() {
        let vc = ListTypeViewController()
        let navi = UINavigationController(rootViewController: vc)
        window?.rootViewController = navi
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }

    func setRoot(type: RootType) {
    }
}

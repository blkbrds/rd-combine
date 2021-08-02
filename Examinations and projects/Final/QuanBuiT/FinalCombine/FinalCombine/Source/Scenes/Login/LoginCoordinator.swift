//
//  LoginCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

enum LoginRoute {
    case signUp
    case register
}

class LoginCoordinator: NavigationCoordinator {

    override func start() {
        super.start()
        let scene = LoginScene(
            dependencies: .init(
                coordinator: self.eraseToAnyCoordinatable()
            )
        )
        self.navigationController.setViewControllers([scene.viewController], animated: false)
    }

    private func showSignUp() {
        SceneDelegate.shared.appCoordinator?.login()
    }

    private func showRegisterVC() {
        let coordinator = RegisterCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.parentCoordinator = self.eraseToAnyCoordinator()
        coordinator.start()
    }
}

extension LoginCoordinator: Coordinatable {

    func coordinate(to route: LoginRoute) {
        switch route {
        case .signUp:
            showSignUp()
        case .register:
            showRegisterVC()
        }
    }
}

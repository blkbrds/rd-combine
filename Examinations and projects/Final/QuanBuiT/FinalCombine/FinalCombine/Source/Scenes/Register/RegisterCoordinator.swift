//
//  RegisterCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

enum RegisterRoute {
    case register
    case cancel
}

class RegisterCoordinator: NavigationCoordinator {
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        super.init(viewController: navigationController)
    }

    override func start() {
        super.start()
        let scene = RegisterScene(
            dependencies: .init(
                coordinator: self.eraseToAnyCoordinatable()
            )
        )
        self.navigationController.pushViewController(scene.viewController, animated: true)
    }

    private func registerAction() {
        SceneDelegate.shared.appCoordinator?.login()
    }

    private func cancelAction() {
        SceneDelegate.shared.appCoordinator?.start()
    }
}

extension RegisterCoordinator: Coordinatable {

    func coordinate(to route: RegisterRoute) {
        switch route {
        case .register:
            registerAction()
        case .cancel:
            cancelAction()
        }
    }
}

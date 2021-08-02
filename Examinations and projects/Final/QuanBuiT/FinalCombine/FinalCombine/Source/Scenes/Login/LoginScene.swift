//
//  LoginScene.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

final class LoginScene {
    // MARK: - Properties
    private let vc: LoginViewController!
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        vc = LoginViewController()
        vc.viewModel = LoginViewModel(coordinator: dependencies.coordinator)
    }
}

// MARK: - Scene Protocol
extension LoginScene: Scene {
    struct Dependencies {
        let coordinator: AnyCoordinatable<LoginRoute>
    }

    var viewController: UIViewController {
        return vc
    }
}

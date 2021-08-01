//
//  RegisterScene.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

final class RegisterScene {
    // MARK: - Properties
    private let vc: RegisterViewController!
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        vc = RegisterViewController()
        vc.viewModel = RegisterViewModel(coordinator: dependencies.coordinator)
    }
}

// MARK: - Scene Protocol
extension RegisterScene: Scene {
    struct Dependencies {
        let coordinator: AnyCoordinatable<RegisterRoute>
    }

    var viewController: UIViewController {
        return vc
    }
}

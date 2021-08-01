//
//  ToDoDetailCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit.UIViewController

// This Coordinator has no `enum Route`.
// It literally means that this is the last screen and no further navigation is possible,
// though you can go back. 😉
class ToDoDetailCoordinator: NavigationCoordinator {
    // MARK: - Enums and Type aliases
    typealias SceneDependencies = ToDoDetailScene.Dependencies
    
    // MARK: - Properties
    private let sceneDependencies: SceneDependencies
    
    // MARK: - Init
    init(navigationController: UINavigationController, sceneDependencies: SceneDependencies) {
        self.sceneDependencies = sceneDependencies
        super.init(viewController: navigationController)
    }

    override func start() {
        super.start()
        let scene = ToDoDetailScene(
            dependencies: .init(
                todoId: sceneDependencies.todoId
            )
        )
        self.navigationController.pushViewController(scene.viewController, animated: true)
    }
}

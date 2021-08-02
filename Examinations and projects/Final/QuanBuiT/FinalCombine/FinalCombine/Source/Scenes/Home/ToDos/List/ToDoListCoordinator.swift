//
//  ToDoCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

enum ToDoListRoute {
    case detail(id: String)
}

class ToDoListCoordinator: NavigationCoordinator {

    override func start() {
        super.start()
        let scene = ToDoListScene(
            dependencies: .init(
                coordinator: self.eraseToAnyCoordinatable()
            )
        )
        self.navigationController.setViewControllers([scene.viewController], animated: false)
    }
}

// MARK: - ViewModel → Coordinator　Callbacks
extension ToDoListCoordinator: Coordinatable {
    
    func coordinate(to route: ToDoListRoute) {
        switch route {
        case .detail(let id):
            showToDoListDetail(id: id)
        }
    }
    
    private func showToDoListDetail(id: String) {
        let coordinator = ToDoDetailCoordinator(
            navigationController: navigationController,
            sceneDependencies: .init(
                todoId: id
            ))
        addChild(coordinator)
        coordinator.parentCoordinator = self.eraseToAnyCoordinator()
        coordinator.start()
    }
}

//
//  SearchCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

enum SearchRoute {
    case detail(id: String)
}

class SearchCoordinator: NavigationCoordinator {

    override func start() {
        super.start()
        let scene = SearchScene(
            dependencies: .init(
                coordinator: self.eraseToAnyCoordinatable()
            )
        )
        self.navigationController.setViewControllers([scene.viewController], animated: false)
    }
}

// MARK: - ViewModel → Coordinator　Callbacks
extension SearchCoordinator: Coordinatable {
    
    func coordinate(to route: SearchRoute) {
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

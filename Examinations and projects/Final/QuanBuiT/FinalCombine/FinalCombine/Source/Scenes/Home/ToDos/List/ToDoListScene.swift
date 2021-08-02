//
//  ToDoListScene.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

final class ToDoListScene {
    // MARK: - Properties
    private let vc: ToDoListViewController!
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        vc = ToDoListViewController()
        vc.viewModel = ToDoListViewModel(coordinator: dependencies.coordinator)
    }
}

// MARK: - Scene Protocol
extension ToDoListScene: Scene {
    struct Dependencies {
        let coordinator: AnyCoordinatable<ToDoListRoute>
    }

    var viewController: UIViewController {
        return vc
    }
}


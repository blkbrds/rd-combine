//
//  ToDoDetailScene.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

final class ToDoDetailScene: Scene {
    // MARK: - Properties
    private let vc: ToDoDetailViewController!
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        vc = ToDoDetailViewController()
        vc.viewModel = ToDoDetailViewModel(todoId: dependencies.todoId)
    }
}

// MARK: - Scene Protocol
extension ToDoDetailScene {
    struct Dependencies {
        let todoId: String
    }

    var viewController: UIViewController {
        return vc
    }
}

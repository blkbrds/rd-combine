//
//  AnyCoordinator.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit.UIViewController

struct AnyCoordinator {

    private let base: CoordinatorType

    init(_ base: CoordinatorType) {
        self.base = base
    }

    func removeChild(_ coordinator: CoordinatorType) {
        base.removeChild(coordinator)
    }
}

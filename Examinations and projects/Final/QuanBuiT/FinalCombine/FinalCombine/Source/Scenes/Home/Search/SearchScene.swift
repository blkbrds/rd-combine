//
//  SearchScene.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit

final class SearchScene {
    // MARK: - Properties
    private let vc: SearchViewController!
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        vc = SearchViewController()
        vc.viewModel = SearchViewModel(coordinator: dependencies.coordinator)
    }
}

// MARK: - Scene Protocol
extension SearchScene: Scene {
    struct Dependencies {
        let coordinator: AnyCoordinatable<SearchRoute>
    }

    var viewController: UIViewController {
        return vc
    }
}

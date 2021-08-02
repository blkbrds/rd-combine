//
//  Coordinatable.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

protocol Coordinatable: class {
    associatedtype Route
    func coordinate(to route: Route)
}

extension Coordinatable {
    func eraseToAnyCoordinatable() -> AnyCoordinatable<Route> {
        AnyCoordinatable(self)
    }
}

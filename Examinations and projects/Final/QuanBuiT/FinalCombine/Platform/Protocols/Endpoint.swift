//
//  Endpoint.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain

protocol Endpoint {
    var relativePath: String { get }
    var headers: [String: String] { get }
}
//
//  ToDosEndpoint.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Domain

enum Endpoints: Endpoint {
    case todos
    case todoDetail
    
    var relativePath: String {
        switch self {
        case .todos:
            return "api/v1/json/1/search_all_leagues.php"
        case .todoDetail:
            return "api/v1/json/1/lookupleague.php"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
}

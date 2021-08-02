//
//  ToDo.swift
//  Domain
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Foundation

public protocol ToDoEntity: Entity {
    // Required
    var idLeague: String { get }
    var strLeague: String { get }
    // `Optional`s
    var strLogo: String? { get }
}

// Conformance to codable done here because it can not be done as extension. Proper place would be in the Platform module
public struct ToDo: Codable {
    // Required
    public let idLeague: String
    public let strLeague: String
    public let intFormedYear: String
    // `Optional`s
    public private(set) var strLogo: String? = nil
}

public struct ToDoDetail: Codable {
    // Required
    public let idLeague: String
    public let strLeague: String
    public let intFormedYear: String
    public let strCountry: String
    // `Optional`s
    public private(set) var strLogo: String? = nil
    public private(set) var strDescriptionEN: String? = nil
    public private(set) var strBadge: String? = nil
    public private(set) var strFanart1: String? = nil
}

extension ToDo: Hashable {
    public static func == (lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.idLeague == rhs.idLeague // For now id comparision is enough
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(idLeague)
    }
}

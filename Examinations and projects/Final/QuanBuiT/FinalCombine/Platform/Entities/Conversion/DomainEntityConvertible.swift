//
//  DomainEntityConvertible.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Foundation

protocol DomainEntityConvertible {
    associatedtype DomainEntity

    func asDomainEntity() -> DomainEntity
}

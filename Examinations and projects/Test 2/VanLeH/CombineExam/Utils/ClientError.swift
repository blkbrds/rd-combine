//
//  ClientError.swift
//  CombineExam
//
//  Created by Van Le H. on 5/7/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation

enum ClientError: Error {
    case unableToCreateRequest
    case invalidResponse
    case unknow
}

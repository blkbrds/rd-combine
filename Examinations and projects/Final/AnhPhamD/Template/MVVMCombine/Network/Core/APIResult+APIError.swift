//
//  APIResult+APIError.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case failure(Error)
    case none
}

enum APIError: Error, LocalizedError {

    case unableToCreateRequest
    case emptyOrInvalidResponse
    case unableToDecode
    case cancelRequest
    case authenticationFailed
    case unknown

    var errorDescription: String? {
        // TODO: - Add common errror message
        return "An error has been occured. Please try again later."
    }
}

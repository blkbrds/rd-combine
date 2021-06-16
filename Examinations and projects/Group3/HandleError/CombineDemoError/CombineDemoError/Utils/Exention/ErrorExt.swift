//
//  ErrorExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import Foundation

extension Error {

    var message: String {
        return localizedDescription
    }
}

extension NSError {

    convenience init(domain: String? = nil, code: Int = -999, message: String) {
        let domain: String = domain.orEmpty
        let userInfo: [String: String] = [NSLocalizedDescriptionKey: message]
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}

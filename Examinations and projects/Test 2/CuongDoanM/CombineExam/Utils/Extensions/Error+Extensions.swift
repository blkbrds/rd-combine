//
//  Error+Extensions.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/20/21.
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

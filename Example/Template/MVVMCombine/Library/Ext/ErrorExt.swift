//
//  ErrorExt.swift
//  MVVMCombine
//
//  Created by Khoa Vo T.A. VN.Danang on 6/8/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

extension Error {

    public var code: Int {
        let `self` = self as NSError
        return self.code
    }
}

//
//  OptionalExt.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/23/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

extension Optional {

    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }

    func unwrapped(or error: Error) throws -> Wrapped {
        guard let this = self else { throw error }
        return this
    }
}

//
//  BundleExt.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

extension Bundle {

    func hasNib(name: String) -> Bool {
        return path(forResource: name, ofType: "nib") != nil
    }
}

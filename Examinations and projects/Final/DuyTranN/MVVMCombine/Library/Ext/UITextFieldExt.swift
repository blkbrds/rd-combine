//
//  UITextFieldExt.swift
//  MVVMCombine
//
//  Created by Duy Tran on 7/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    var value: String {
        guard let string = self.text else { return "" }
        return string
    }
}

//
//  ButtonExt.swift
//  CombineExam
//
//  Created by Toan Nguyen D. [4] on 4/13/21.
//

import Foundation
import UIKit
import Combine

extension UIButton {
    var isValid: Bool {
        get {
            return isEnabled && backgroundColor == #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        }
        set {
            backgroundColor = newValue ? #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            isEnabled = newValue
        }
    }
}

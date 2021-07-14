//
//  UITextFieldExts.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/14/21.
//

import Foundation
import UIKit

extension UITextField {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

//
//  StringExts.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/22/21.
//

import Foundation

extension String {
    // 7 to 18 word characters
    func isUsernameInput() -> Bool {
        let usernameRegEx = "\\w{7,18}"
        return NSPredicate(format:"SELF MATCHES %@", usernameRegEx).evaluate(with: self)
    }

    // Minimum 8 characters at least 1 Alphabet and 1 Number
    func isPasswordRegEx() -> Bool {
        let passwordRegEx: String = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self)
    }
}

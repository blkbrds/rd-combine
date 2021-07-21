//
//  StringExt.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/23/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {
    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}

extension String {

    enum Process {
        case encode
        case decode
    }

    // MARK: Trimmed
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func trimmedTextByLimit(limit: Int) -> String {
        if isEmpty || count <= limit {
            return self
        } else {
            return String(self.prefix(limit))
        }
    }

    // The offset into a string's UTF-16 encoding for endIndex of self
    var endEncodedOffset: Int {
        return endIndex.utf16Offset(in: self)
    }

    func base64(_ method: Process) -> String? {
        switch method {
        case .encode:
            return data(using: .utf8)?.base64EncodedString()
        case .decode:
            guard let data = Data(base64Encoded: self) else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }

    // MARK: String size
    func contentHeight(contentWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        let constraintRect = CGSize(width: contentWidth, height: .greatestFiniteMagnitude)
        let boundingBox = attributedString.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return boundingBox.height
    }

    func contentWidth(font: UIFont) -> CGFloat {
        let size = (self as NSString).size(withAttributes: [.font: font])
        return size.width
    }

    // MARK: Validation

    func isValid(with regression: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regression).evaluate(with: self)
    }

    // Validation
    func contains(_ contains: [Regressions.Contains]) -> Bool {
        var regex: String = contains.map { $0.regrex }.joined()
        regex = "^[" + regex + "]+$"
        return isValid(with: regex)
    }

    func isAllWhiteSpace() -> Bool {
        return trimmingCharacters(in: .whitespaces) == ""
    }

    var containsFullwidthCharacters: Bool {
        return unicodeScalars.contains { $0.isFullwidth }
    }

    var containsHalfwidthCharacters: Bool {
        return unicodeScalars.contains { $0.isHalfwidth }
    }

    var containsKatakanaHalfWidthCharacter: Bool {
        return unicodeScalars.contains { $0.isKatakanaHalfWidth }
    }

    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
}

extension NSMutableAttributedString {
    // Change text to link 
    func setAsLink( textToFind: String, linkName: String) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkName, range: foundRange)
        }
    }
}

func / (lhs: String, rhs: String) -> String {
    return lhs + "/" + rhs
}

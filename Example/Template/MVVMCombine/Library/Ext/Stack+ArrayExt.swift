//
//  Stack+ArrayExt.swift
//  MVVMCombine
//
//  Created by MBA0052 on 5/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        let removedSubviews = arrangedSubviews.reduce([]) { (removedSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return removedSubviews + [subview]
        }
        return removedSubviews
    }
}

extension Array where Element: AnyObject {
    mutating func removeFirst(object: AnyObject) {
        guard let index = firstIndex(where: { $0 === object }) else { return }
        remove(at: index)
    }
}

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
}

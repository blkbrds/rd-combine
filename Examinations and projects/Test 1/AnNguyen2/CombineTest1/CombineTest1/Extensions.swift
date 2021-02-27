//
//  UIViewExt.swift
//  CombineTest1
//
//  Created by MBA0283F on 2/26/21.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            layer.cornerRadius
        }
    }
}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

extension Notification.Name {
    static let didReceiveInfo = Notification.Name("didReceiveInfo")
}




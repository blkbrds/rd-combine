//
//  PaddingLabel.swift
//  MVVMCombine
//
//  Created by MBA0242P on 5/6/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingLabel: Label {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0

    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.width += leftInset + rightInset
        newSize.height += topInset + bottomInset
        return newSize
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        return contentSize
    }
}

//
//  TextFieldExt.swift
//  Foody
//
//  Created by MBA0283F on 3/15/21.
//

import SwiftUI

public var arrTextFieldEditActions: [TextFieldEditActions] = [.all]

public enum TextFieldEditActions {
    case all
    case copy, paste, select, selectAll, delete, cut
    case decreaseSize, increaseSize
    case toggleItalics, toggleBoldface, toggleUnderline
    case makeTextWritingDirectionLeftToRight, makeTextWritingDirectionRightToLeft
    
    var selector: Selector {
        switch self {
        case .all:
            return #selector(UIResponderStandardEditActions.`self`)
        case .copy:
            return #selector(UIResponderStandardEditActions.copy)
        case .paste:
            return #selector(UIResponderStandardEditActions.paste)
        case .select:
            return #selector(UIResponderStandardEditActions.select)
        case .selectAll:
            return #selector(UIResponderStandardEditActions.selectAll)
        case .delete:
            return #selector(UIResponderStandardEditActions.delete)
        case .cut:
            return #selector(UIResponderStandardEditActions.cut)
        case .decreaseSize:
            return #selector(UIResponderStandardEditActions.decreaseSize)
        case .increaseSize:
            return #selector(UIResponderStandardEditActions.increaseSize)
        case .toggleItalics:
            return #selector(UIResponderStandardEditActions.toggleItalics)
        case .toggleBoldface:
            return #selector(UIResponderStandardEditActions.toggleBoldface)
        case .toggleUnderline:
            return #selector(UIResponderStandardEditActions.toggleUnderline)
        case .makeTextWritingDirectionLeftToRight:
            return #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight)
        case .makeTextWritingDirectionRightToLeft:
            return #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft)
        }
    }
}
//
//extension UITextField {
//    open override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
//
//        if arrTextFieldEditActions.contains(where: {$0 == .all}) || arrTextFieldEditActions.contains(where: {$0.selector == action}) {
//            return nil
//        }
//
//        return super.target(forAction: action, withSender: sender)
//    }
//}

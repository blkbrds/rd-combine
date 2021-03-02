//
//  ExtButton.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/1/21.
//

import Foundation
import UIKit

extension UIButton {
    public func setAllStatesTitle(_ newTitle: String){
        self.setTitle(newTitle, for: .normal)
        self.setTitle(newTitle, for: .selected)
        self.setTitle(newTitle, for: .disabled)
        self.titleLabel?.textAlignment = .center
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
    }
}

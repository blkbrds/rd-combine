//
//  TextFieldExt.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/15/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    var publisher: AnyPublisher<String?,Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField? }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}

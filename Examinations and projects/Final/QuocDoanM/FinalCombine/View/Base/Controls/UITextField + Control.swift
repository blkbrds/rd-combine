//
//  UITextField + Control.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/14/21.
//

import UIKit
import Combine

extension UITextField {
//    var textPublisher: AnyPublisher<String, Never> {
//        publisher(for: .)
//            .map { self.text ?? "" }
//            .eraseToAnyPublisher()
//    }

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

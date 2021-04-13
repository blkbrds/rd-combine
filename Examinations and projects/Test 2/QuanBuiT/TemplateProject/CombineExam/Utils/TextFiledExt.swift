//
//  TextFiledExt.swift
//  CombineExam
//
//  Created by MBA0253P on 4/13/21.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    var publisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField? }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}

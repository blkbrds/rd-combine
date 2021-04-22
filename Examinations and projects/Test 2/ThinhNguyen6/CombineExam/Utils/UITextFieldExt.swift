//
//  UITextFieldExt.swift
//  CombineExam
//
//  Created by MBA0052 on 4/20/21.
//

import Foundation
import UIKit
import Combine

extension UITextField {
  var publisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextField }
      .map { $0.text ?? ""}
      .eraseToAnyPublisher()
  }
}

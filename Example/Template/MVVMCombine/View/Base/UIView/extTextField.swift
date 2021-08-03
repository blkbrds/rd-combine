//
//  extTextField.swift
//  MVVMCombine
//
//  Created by Tam Nguyen 7 on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension UITextField {
  var publisher: AnyPublisher<String?, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextField? }
      .map { $0?.text }
      .eraseToAnyPublisher()
  }
}

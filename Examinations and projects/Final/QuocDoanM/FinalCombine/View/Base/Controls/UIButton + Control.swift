//
//  UIButton + Control.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/14/21.
//

import UIKit
import Combine

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
    }
}

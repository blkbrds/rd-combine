//
//  UIControl + Ext.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/14/21.
//

import UIKit
import Combine

extension UIControl {
    func publisher(for event: Event) -> EventPublisher<UIControl> {
        EventPublisher(control: self,
                       event: event
        )
    }
}

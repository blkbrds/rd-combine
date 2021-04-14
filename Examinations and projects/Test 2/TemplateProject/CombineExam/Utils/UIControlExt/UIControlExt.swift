//
//  UIControlExt.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        return UIControlPublisher(control: self, events: events)
    }
}






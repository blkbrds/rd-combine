//
//  UIViewExt.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import Foundation
import UIKit
import SwiftUtils

extension UIView {

    func addInnerShadow() {
        let innerShadow = CALayer()
        innerShadow.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: bounds.height)

        // Shadow path (1pt ring around bounds)
        let radius: CGFloat = 8
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -1, dy: -1), cornerRadius: radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius: radius).reversing()

        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true

        // Shadow properties
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 3)
        innerShadow.shadowOpacity = 0.2
        innerShadow.shadowRadius = 3
        innerShadow.cornerRadius = 8
        layer.addSublayer(innerShadow)
    }

    func addTouchGestureToEndEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleDismiss() {
        endEditing(true)
    }
}

//
//  UIViewControllerExt.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import Foundation
import UIKit

extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

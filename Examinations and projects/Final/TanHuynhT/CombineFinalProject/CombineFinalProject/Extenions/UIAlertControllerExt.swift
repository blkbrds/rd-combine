//
//  UIAlertControllerExt.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/23/21.
//

import Foundation
import UIKit

extension UIAlertController {

    open class func alertWithError(_ error: Error, handler: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription.localized(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: handler)
        }))
        return alert
    }
}

//
//  UIApplication.swift
//  Foody
//
//  Created by An Nguyễn on 05/05/2021.
//

import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }
}

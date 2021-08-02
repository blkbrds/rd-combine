//
//  UIImageViewExt.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(path: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: path) else {
            image = placeholder
            return
        }
        kf.setImage(with: url, placeholder: placeholder)
    }
}

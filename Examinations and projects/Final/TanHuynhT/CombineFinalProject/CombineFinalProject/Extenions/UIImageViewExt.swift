//
//  UIImageViewExt.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/22/21.
//

import Foundation
import SDWebImage

extension UIImageView {

    func setImageWithURL(_ urlString: String?, placeholder: String? = nil, afterSecond: Double = 0.01) {
        var placeholderImage: UIImage?
        if let placeholder = placeholder, let image = UIImage(named: placeholder) {
            placeholderImage = image
        } else {
            placeholderImage = UIColor.white.image()
        }

        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }

        if afterSecond == 0.0 {
            let viewSize = self.bounds.size
            guard viewSize.width > 0 && viewSize.height > 0 else { return }
            self.sd_setImage(with: url, placeholderImage: placeholderImage)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + afterSecond) {
            let viewSize = self.bounds.size
            guard viewSize.width > 0 && viewSize.height > 0 else { return }
            self.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
    }
}

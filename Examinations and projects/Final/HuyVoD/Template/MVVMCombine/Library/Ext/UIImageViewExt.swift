//
//  UiImageViewExt.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {

    func setImage(urlString: String?, placeholderImage: UIImage?, options: SDWebImageOptions = [.continueInBackground, .retryFailed], completion: ((UIImage?, String?) -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: options) { (image, _, _, url) in
            DispatchQueue.main.async {
                completion?(image, url?.absoluteString)
            }
        }
    }
}

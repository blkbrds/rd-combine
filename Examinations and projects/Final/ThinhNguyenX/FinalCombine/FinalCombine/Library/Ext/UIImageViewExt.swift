//
//  UIImageViewExt.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import UIKit
import Combine

extension UIImageView {

    func setImage(_ imageURL: String, placeholder image: UIImage? = nil) -> AnyCancellable? {
        guard let url = URL(string: imageURL) else {
            return nil
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in
                guard let image = UIImage(data: data) else {
                    return nil
                }
                return image
            }
            .replaceError(with: image)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

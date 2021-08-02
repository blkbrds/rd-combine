//
//  UIImageView.Ext.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 31/07/2021.
//

import Foundation
import UIKit
import Combine

extension UIImageView {
    func downloaded(from url: URL) -> AnyCancellable {
        return URLSession.shared.dataTaskPublisher(for: url)
            .sink { (_) in
            } receiveValue: { [weak self] (data, response) in
                guard let httpURLResponse = response as? HTTPURLResponse,               httpURLResponse.statusCode == 200,
                      let mimeType = response.mimeType, mimeType.hasPrefix("image"),
                      let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }
    }
}

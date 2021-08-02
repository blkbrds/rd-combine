//
//  API.Downloader.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 8/1/21.
//

import UIKit
import Combine

extension API.Downloader {
    static func image(urlString: String) -> AnyPublisher<UIImage?, APIError> {
      guard let url = URL(string: urlString) else {
        return Fail(error: APIError.errorURL).eraseToAnyPublisher()
      }
      
      return APIManager.request(url: url)
      .map { UIImage(data: $0) }
      .mapError { $0 as? APIError ?? .unknown }
      .eraseToAnyPublisher()
    }
}

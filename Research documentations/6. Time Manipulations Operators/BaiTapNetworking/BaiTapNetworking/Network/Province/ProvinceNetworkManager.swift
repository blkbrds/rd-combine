//
//  ProvinceNetworkManager.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation
import Combine

final class ProvinceNetWorkManager: ProvinceNetworkable {

    var provider: Provider<ProvinceService> = Provider<ProvinceService>()

    func getName() -> AnyPublisher<ProvinceResponseData, Error> {
        return provider.request(target: .getName)
        .catchAPIError()
        .decode(ProvinceResponseData.self)
    }
}

extension ProvinceNetWorkManager {

    struct ProvinceResponseData: Codable {
        var data: [Province]?

        enum CodingKeys: String, CodingKey {
            case data = "LtsItem" 
        }
    }
}



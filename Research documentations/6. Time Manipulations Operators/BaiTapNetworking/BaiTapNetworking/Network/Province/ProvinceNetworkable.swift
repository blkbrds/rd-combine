//
//  ProvinceNetworkable.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation
import Combine

typealias Parameters = [String: Any]

protocol ProvinceNetworkable {

    func getName() -> AnyPublisher<ProvinceNetWorkManager.ProvinceResponseData, Error>
}

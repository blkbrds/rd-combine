//
//  Measurement.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

typealias Measurement = App.Measurement

extension App {

    struct Measurement {
        static var tabBarHeight: CGFloat {
            return 66
        }

        static var homeButtonHeight: CGFloat {
            if isNotchIphone {
                return 34
            } else {
                return 0
            }
        }

        static var statusBarHeight: CGFloat {
            if isNotchIphone {
                return 44
            } else {
                return 20
            }
        }

        static let navigationBarHeight: CGFloat = 44

        static let naviBarEdgeInsets = UIEdgeInsets(top: Measurement.statusBarHeight, left: 0, bottom: 0, right: 0)

        static let indicatorContainerSize: CGFloat = 80
        static let indicatorSize: CGFloat = 50
    }
}

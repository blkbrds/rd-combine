//
//  Measurement.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 8/2/21.
//

import UIKit

typealias Measurement = App.Measurement

extension App {

    struct Measurement {
        static var tabBarHeight: CGFloat {
            if iPhoneX || iPhoneXR {
                return 92
            } else {
                return 57
            }
        }

        static var homeButtonHeight: CGFloat {
            if iPhoneX || iPhoneXR {
                return 34
            } else {
                return 0
            }
        }

        static var statusBarHeight: CGFloat {
            if iPhoneX || iPhoneXR {
                return 44
            } else {
                return 20
            }
        }
    }
}

//
//  DeviceType.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

public enum DeviceType {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6p
    case iPhoneX
    case iPhoneXS
    case iPhoneXR
    case iPhoneXSMax
    case iPhone12
    case iPhone12ProMax
    case iPad
    case iPadPro105
    case iPadPro129

    public var size: CGSize {
        switch self {
        case .iPhone4: return CGSize(width: 320, height: 480)
        case .iPhone5: return CGSize(width: 320, height: 568)
        case .iPhone6: return CGSize(width: 375, height: 667)
        case .iPhone6p: return CGSize(width: 414, height: 736)
        case .iPhoneX: return CGSize(width: 375, height: 812)
        case .iPhoneXS: return CGSize(width: 375, height: 812)
        case .iPhoneXR: return CGSize(width: 414, height: 896)
        case .iPhoneXSMax: return CGSize(width: 414, height: 896)
        case .iPhone12: return CGSize(width: 390, height: 844)
        case .iPhone12ProMax: return CGSize(width: 428, height: 926)
        case .iPad: return CGSize(width: 768, height: 1_024)
        case .iPadPro105: return CGSize(width: 834, height: 1_112)
        case .iPadPro129: return CGSize(width: 1_024, height: 1_366)
        }
    }
}

public let kScreenSize = UIScreen.main.bounds.size
public let ratioWidth = kScreenSize.width / DeviceType.iPhone6.size.width
public let ratioHeight = kScreenSize.height / DeviceType.iPhone6.size.height

public let iPhone = (UIDevice.current.userInterfaceIdiom == .phone)
public let iPad = (UIDevice.current.userInterfaceIdiom == .pad)

public let iPhone4 = (iPhone && DeviceType.iPhone4.size == kScreenSize)
public let iPhone5 = (iPhone && DeviceType.iPhone5.size == kScreenSize)
public let iPhone6 = (iPhone && DeviceType.iPhone6.size == kScreenSize)
public let iPhone6p = (iPhone && DeviceType.iPhone6p.size == kScreenSize)
public let iPhoneX = (iPhone && DeviceType.iPhoneX.size == kScreenSize)
public let iPhoneXS = (iPhone && DeviceType.iPhoneXS.size == kScreenSize)
public let iPhoneXR = (iPhone && DeviceType.iPhoneXR.size == kScreenSize)
public let iPhoneXSMax = (iPhone && DeviceType.iPhoneXSMax.size == kScreenSize)
public let iPhone12 = (iPhone && DeviceType.iPhone12.size == kScreenSize)
public let iPhone12ProMax = (iPhone && DeviceType.iPhone12ProMax.size == kScreenSize)
public var isNotchIphone: Bool {
    if iPhone4 || iPhone5 || iPhone6 || iPhone6p {
        return false
    }
    return true
}

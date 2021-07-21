//
//  AppConfiguration.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/23/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

/// It will help you get some values more secrectly by environments config.
final class AppConfiguration {

    /// Get the value according to the given key in your bundle
    ///
    /// - Parameter key: The keys that you defined in .xcconfig file
    /// - Returns: The accordingly value
    static func infoForKey(_ key: String) -> String? {
        guard let configs = Bundle.main.infoDictionary?["App Configurations"] as? [String: String],
            let value = configs[key] else { return nil }
        return value.replacingOccurrences(of: "\\", with: "")
    }

    /// Get the value according to the given key in your bundle
    ///
    /// - Parameter key: The keys that you defined `AppConfigurationKeys`
    /// - Returns: The accordingly value
    static func infoForKey(_ key: AppConfigurationKeys) -> String? {
        guard let configs = Bundle.main.infoDictionary?["App Configurations"] as? [String: String],
            let value = configs[key.rawValue] else { return nil }
        return value.replacingOccurrences(of: "\\", with: "")
    }

    static func getAppVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
        return appVersion
    }
}

/// Define some keys that using in .xcconfig file. It help you less confused and get correctly values
///
/// - displayName: The app name
/// - baseURL: The base url to request API

enum AppConfigurationKeys: String {

    // API
    case baseURL = "BASE_URL"
    case apiVersion = "API_VERSION"
    case apiKey = "API_KEY"

    // X Rate Limit
    case limit = "X_RATE_LIMIT_LIMIT"
    case interval = "X_RATE_LIMIT_INTERVAL"
}

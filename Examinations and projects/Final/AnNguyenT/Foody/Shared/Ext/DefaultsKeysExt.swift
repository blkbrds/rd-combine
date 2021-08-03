//
//  DefaultsKeys.swift
//  Foody
//
//  Created by MBA0283F on 4/23/21.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var currentEmail: DefaultsKey<String> { .init("currentEmail", defaultValue: "") }
    var accessToken: DefaultsKey<String?> { .init("accessToken") }
    var currentUser: DefaultsKey<User?> { .init("currentUser") }
    var restaurant: DefaultsKey<Restaurant?> { .init("restaurant") }
    var isShowedOnboarding: DefaultsKey<Bool> { .init("isShowedOnboarding", defaultValue: false) }
}

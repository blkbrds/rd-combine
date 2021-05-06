//
//  UserViewCombineWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

// 4. Combine

final class UserViewCombineWay: UserView {

    var goToEditAction = PassthroughSubject<Int, Never>()

    var subscription = Set<AnyCancellable>()

    override func editButtonTouchUpInside(_ sender: Any) {
        goToEditAction.send(tag)
    }
}

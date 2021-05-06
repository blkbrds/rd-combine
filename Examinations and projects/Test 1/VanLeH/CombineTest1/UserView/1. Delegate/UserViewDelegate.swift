//
//  UserViewDelegate.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

// 1. Delegate

protocol UserViewDelegate: class {
    func view(_ view: UserViewDelegateWay, needPerforms action: UserViewDelegateWay.Action)
}

final class UserViewDelegateWay: UserView {

    enum Action {
        case goToEdit(userAtIndex: Int)
    }

    weak var delegate: UserViewDelegate?

    override func editButtonTouchUpInside(_ sender: Any) {
        delegate?.view(self, needPerforms: .goToEdit(userAtIndex: tag))
    }
}

//
//  UserViewClosureWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

// 2. Closure

final class UserViewClosureWay: UserView {

    var goToEdit: ((Int) -> (Void))?

    override func editButtonTouchUpInside(_ sender: Any) {
        goToEdit?(tag)
    }
}

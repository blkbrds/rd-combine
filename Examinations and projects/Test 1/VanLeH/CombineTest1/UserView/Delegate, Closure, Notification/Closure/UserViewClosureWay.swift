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

    // MARK: Override function
    override func configUI() {
        super.configUI()
        guard let viewModel = viewModel as? UserViewModelNormalWay else { return }
        configUIWithUser(viewModel.user)
    }

    override func editButtonTouchUpInside(_ sender: Any) {
        goToEdit?(tag)
    }
}

//
//  UserViewNotifictaionWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

// 3. Notification

final class UserViewNotifictaionWay: UserView {

    // MARK: Override function
    override func configUI() {
        super.configUI()
        guard let viewModel = viewModel as? UserViewModelNormalWay else { return }
        configUIWithUser(viewModel.user)
    }

    override func editButtonTouchUpInside(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("goToEdit"), object: ["userAtIndex": tag])
    }
}

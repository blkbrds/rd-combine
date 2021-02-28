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

    // MARK: Override function
    override func configUI() {
        super.configUI()
        configObserver()
    }

    override func editButtonTouchUpInside(_ sender: Any) {
        goToEditAction.send(tag)
    }

    private func configObserver() {
        guard let viewModel = viewModel as? UserViewModelCombineWay else { return }
        viewModel.userSubject
            .sink(receiveValue: { [weak self] user in
                self?.configUIWithUser(user)
            })
            .store(in: &subscription)
    }
}

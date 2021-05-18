//
//  WelcomeViewController.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/19/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

class WelcomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!

    let viewModel = WelcomeViewModel(user: .init(name: "F1x", about: "Ad1min", isLogin: false))
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello WelcomeVC"

        viewModel.name
            .assign(to: \.text, on: nameLabel)
        .store(in: &subscriptions)

        viewModel.about
            .assign(to: \.text, on: aboutLabel)
        .store(in: &subscriptions)

        viewModel.loginEnabled
            .sink { isLogin in
                guard let isLogin = isLogin else { return }
                self.loginButton.isEnabled = !isLogin
                self.homeButton.isEnabled = isLogin
        }
    .store(in: &subscriptions)
    }

    // MARK: - IBActions

    @IBAction func homeButtonTouchUpInside(_ sender: Any) {
        viewModel.action.send(.gotoHome)
    }

    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        viewModel.action.send(.gotoLogin)
    }

}

//
//  LoginViewController.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/28/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class LoginViewController: ViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    // MARK: - Properties
    var viewModel: LoginViewModel?
    let trueUser: String = "Thientam123"
    let truePass: String = "Anhieuem123"

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
    }

    override func setupData() {
        super.setupData()
    }

    override func binding() {
        super.binding()
        viewModel?.isEnabled
            .sink(receiveValue: { isLogin in
                self.loginButton.isEnabled = !isLogin
            })
            .store(in: &subscriptions)
    }

    @IBAction private func doneButtonTouchUpInside(_ sender: UIButton) {
        viewModel?.action.send(.gotoTeamVC)
//        let vc = TeamViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

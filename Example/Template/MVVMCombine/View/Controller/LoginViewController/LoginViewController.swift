//
//  LoginViewController.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/28/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class LoginViewController: BaseViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    // MARK: - Properties
    var viewModel = LoginViewModel(username: "thientam123", password: "thientam123")

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        let clearButton = UIBarButtonItem(title: "clear", style: .plain, target: self, action: #selector(clear))
        navigationItem.leftBarButtonItem = clearButton
    }

    override func setupData() {
        super.setupData()
    }

    override func bindingToView() {
        super.bindingToView()

        viewModel.$username
            .assign(to: \.text, on: usernameTextField)
            .store(in: &subcriptions)

        viewModel.$password
            .assign(to: \.text, on: passwordTextField)
            .store(in: &subcriptions)

        viewModel.validatedText
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subcriptions)
    }

    override func bindingToViewModel() {
        super.bindingToViewModel()

        usernameTextField.publisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subcriptions)

        passwordTextField.publisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subcriptions)
    }

    override func router() {
        super.router()
        viewModel.state
            .sink { [weak self] state in
            switch state {
            case .error(message: let mess):
                _ = self?.alert(title: "Combine", text: mess)
            case .logined:
                let vc = TeamViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            case .initial:
                break
            }
        }
            .store(in: &subcriptions)
    }

    @IBAction private func doneButtonTouchUpInsde(_ sender: Any) {
        viewModel.action.send(.login)
    }
    @objc private func clear() {
        viewModel.action.send(.clear)
    }
}

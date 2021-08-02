//
//  LoginViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/12/21.
//

import UIKit
import Combine

final class LoginViewController: ViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var userNameTitleLabel: UILabel!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userNameWarningLabel: UILabel!
    @IBOutlet private weak var passwordTitleLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordWarningLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var forgetPasswordButton: UIButton!
    @IBOutlet private weak var desTitleLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!

    var viewModel: LoginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
        // Label
        titleLabel.text = Strings.Login.login
        userNameTitleLabel.text = Strings.Login.userName
        passwordTitleLabel.text = Strings.Login.password
        desTitleLabel.text = Strings.Login.noHaveAccount
        // Textfield
        userNameTextField.placeholder = Strings.Login.userNamePlaceholder
        passwordTextField.placeholder = Strings.Login.passwordPlaceholder
        // Button
        forgetPasswordButton.setTitle(Strings.Login.forgotPassword, for: .normal)
        loginButton.layer.cornerRadius = 16
        loginButton.setTitle(Strings.Login.login, for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        registerButton.setTitle(Strings.Login.createAccount, for: .normal)
    }

    override func bindingToViewModel() {
        // Binding
        userNameTextField.textPublisher
            .assign(to: \.userName, on: viewModel)
            .store(in: &viewModel.cancellables)

        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        // Buttons
        loginButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                guard let this = self else { return }
                this.viewModel.checkUser
                    .sink { error in
                        switch error {
                        case .match:
                            this.transitionScreen()
                        case .noMatch:
                            _ = this.alert(text: "\(error.message)\n\(error.localizedDescription)")
                        default:
                            break
                        }
                    }
                    .store(in: &this.subscriptions)
            }).store(in: &subscriptions)

        registerButton.tapPublisher
            .sink { _ in
                SceneDelegate.shared.setRoot(type: .register)
            }.store(in: &subscriptions)
        
        // Validate
        viewModel.validateUserName
            .dropFirst()
            .sink { [weak self] type in
                guard let this = self else { return }
                this.userNameWarningLabel.isHidden = type == .none
                this.userNameWarningLabel.text = type.message
            }
            .store(in: &viewModel.cancellables)

        viewModel.validatePassword
            .dropFirst()
            .sink { [weak self] type in
                guard let this = self else { return }
                this.passwordWarningLabel.isHidden = type == .none
                this.passwordWarningLabel.text = type.message
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.readyToLogin
            .sink { [weak self] isEnable in
                guard let this = self else { return }
                this.loginButton.isEnabled = isEnable
                this.loginButton.backgroundColor = isEnable ? .systemPurple : .systemGray
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - Private func
extension LoginViewController {
    private func transitionScreen() {
        SceneDelegate.shared.setRoot(type: .top)
    }
}

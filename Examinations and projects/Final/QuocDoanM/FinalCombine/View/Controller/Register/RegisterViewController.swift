//
//  RegisterViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/12/21.
//

import UIKit

final class RegisterViewController: ViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var userNameTitleLabel: UILabel!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userNameWarningLabel: UILabel!
    @IBOutlet private weak var passwordTitleLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordWarningLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTitleLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordWarningLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!

    var viewModel: RegisterViewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        // Label
        titleLabel.text = Strings.Login.register
        userNameTitleLabel.text = Strings.Login.userName
        passwordTitleLabel.text = Strings.Login.password
        confirmPasswordTitleLabel.text = Strings.Login.confirmPassword
        // Textfield
        userNameTextField.placeholder = Strings.Login.userNamePlaceholder
        passwordTextField.placeholder = Strings.Login.passwordPlaceholder
        confirmPasswordTextField.placeholder = Strings.Login.confirmPasswordPlaceholder
        // Button
        registerButton.setTitle(Strings.Login.register, for: .normal)
    }

    override func binding() {
        super.binding()

        userNameTextField.textPublisher
            .assign(to: \.userName, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)

        confirmPasswordTextField.textPublisher
            .assign(to: \.confirmPassword, on: viewModel)
            .store(in: &subscriptions)

        // Error
        viewModel.userNameError
            .sink { [weak self] error in
                guard let this = self else { return }
                switch error {
                case .invalidUserName:
                    this.userNameWarningLabel.text = error.localizedDescription
                case .unknown:
                    _ = this.alert(text: error.localizedDescription)
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        viewModel.passwordError
            .sink { [weak self] error in
                guard let this = self else { return }
                switch error {
                case .invalidPassword:
                    this.passwordWarningLabel.text = error.localizedDescription
                case .invalidConfirmPassword:
                    this.confirmPasswordWarningLabel.text = error.localizedDescription
                case .unknown:
                    _ = this.alert(text: error.localizedDescription)
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        // Validate
        viewModel.validateUserName
            .dropFirst()
            .sink { error in
                switch error {
                case .invalidUserName:
                    self.viewModel.userNameError.send(error)
                case .passed:
                    self.userNameWarningLabel.text = ""
                default:
                    break
                }
            }.store(in: &subscriptions)

        viewModel.validatePassword
            .dropFirst()
            .sink { error in
                switch error {
                case .invalidPassword:
                    self.viewModel.passwordError.send(error)
                case .passed:
                    self.passwordWarningLabel.text = ""
                default:
                    break
                }
            }.store(in: &subscriptions)

        viewModel.validateConfirmPassword
            .sink { [weak self] error in
                guard let this = self else { return }
                switch error {
                case .invalidConfirmPassword:
                    this.viewModel.passwordError.send(error)
                case .passed:
                    this.confirmPasswordWarningLabel.text = ""
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        registerButton.tapPublisher
            .sink { [weak self] _ in
                self?.saveUser()
                self?.transitionLogin()
            }
            .store(in: &subscriptions)

        viewModel.readyToRegister
            .sink { [weak self] isEnable in
                self?.registerButton.isEnabled = isEnable
                self?.registerButton.backgroundColor = isEnable ? .systemPurple : .systemGray
            }.store(in: &subscriptions)
    }
}

// MARK: - Private func
extension RegisterViewController {
    private func transitionLogin() {
        SceneDelegate.shared.setRoot(type: .login)
    }

    private func saveUser() {
        let userRegistered: UserResponse = UserResponse()
        userRegistered.userName = viewModel.userName
        userRegistered.password = viewModel.password
        Session.shared.users = [userRegistered]
    }
}

//
//  RegisterViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import UIKit

final class RegisterViewController: ViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rePasswordTextField: UITextField!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var rePasswordView: UIView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var rePasswordErrorLabel: UILabel!
    @IBOutlet private weak var passwordSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rePasswordSpaceConstraint: NSLayoutConstraint!
    
    var viewModel: RegisterViewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Life cycles
    override func setupUI() {
        super.setupUI()
        view.addTouchGestureToEndEditing()

        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor.lightGray.cgColor
        emailView.layer.cornerRadius = 10
        emailView.addInnerShadow()

        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.lightGray.cgColor
        passwordView.layer.cornerRadius = 10
        passwordView.addInnerShadow()

        rePasswordView.layer.borderWidth = 1
        rePasswordView.layer.borderColor = UIColor.lightGray.cgColor
        rePasswordView.layer.cornerRadius = 10
        rePasswordView.addInnerShadow()

        setupTextField()
    }

    override func setupData() {
        super.setupData()
    }

    override func binding() {
        super.binding()
        // Binding error
        viewModel.$emailApiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        viewModel.$registerApiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        // Binding data
        viewModel.isEmailValid
            .sink { [weak self] isNotExisting in
                guard let this = self,
                      let email = this.emailTextField.text,
                      let password = this.passwordTextField.text else { return }
                if isNotExisting {
                    this.register(email: email, password: password)
                } else {
                    this.showAlert(message: "Email already exists!")
                }
            }
            .store(in: &subscriptions)

        viewModel.isRegisterSuccess
            .sink { [weak self] isSuccess in
                guard let this = self,
                      let email = this.emailTextField.text,
                      let password = this.passwordTextField.text else { return }
                if isSuccess {
                    this.goToLogin(email: email, password: password)
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - Privates
    private func setupTextField() {
        // Create publisher for textfield
        let emailTextFieldPublisher = emailTextField.textPublisher()
        let passwordTextFieldPublisher = passwordTextField.textPublisher()
        let repPasswordTextFieldPublisher = rePasswordTextField.textPublisher()

        // Observe to show error message
        emailTextFieldPublisher
            .map({ [weak self] email -> Bool in
                guard let this = self else { return false }
                return email.isEmpty ? true : this.viewModel.isValidEmail(email)
            })
            .handleEvents(receiveOutput: { _ in
            })
            .assign(to: \.isHidden, on: emailErrorLabel)
            .store(in: &subscriptions)

        passwordTextFieldPublisher
            .map({ [weak self] password -> Bool in
                guard let this = self else { return false }
                return password.isEmpty ? true : this.viewModel.isValidPassword(password: password)
            })
            .handleEvents(receiveOutput: { isValid in
                self.passwordSpaceConstraint.constant = isValid ? 25 : 40
            })
            .assign(to: \.isHidden, on: passwordErrorLabel)
            .store(in: &subscriptions)

        // Observe to enable register button
        emailTextFieldPublisher
            .combineLatest(passwordTextFieldPublisher, repPasswordTextFieldPublisher)
            .map({ [weak self] email, password, rePassword -> Bool in
                guard let this = self else { return false }
                return this.viewModel.isValidEmail(email)
                    && this.viewModel.isValidPassword(password: password)
                    && this.viewModel.isValidPassword(password: rePassword)
            })
            .handleEvents(receiveOutput: { _ in
            })
            .assign(to: \.isEnabled, on: registerButton)
            .store(in: &subscriptions)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

    func checkEmailNotExisting(email: String, password: String) {
        viewModel.checkEmailNotExisting(email: email)
    }

    func register(email: String, password: String) {
        viewModel.register(email: email, password: password)
    }

    private func goToLogin(email: String, password: String) {
        viewModel.publisher.send((email, password))
        viewModel.publisher.send(completion: .finished)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - IBAction
    @IBAction private func register(_ sender: Any?) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let rePassword = rePasswordTextField.text else { return }
        if !viewModel.isCorrectPassword(password: password, rePassword: rePassword) {
            showAlert(message: "Re-password is not match with password!")
        } else {
            checkEmailNotExisting(email: email, password: password)
        }
    }
}

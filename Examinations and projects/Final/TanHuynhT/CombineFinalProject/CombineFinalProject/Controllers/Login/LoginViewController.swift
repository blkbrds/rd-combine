//
//  LoginViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import UIKit
import Firebase
import Combine

final class LoginViewController: ViewController {

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userNameView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginViewModel = LoginViewModel()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func setupUI() {
        super.setupUI()
        view.addTouchGestureToEndEditing()

        userNameView.layer.borderWidth = 1
        userNameView.layer.borderColor = UIColor.lightGray.cgColor
        userNameView.layer.cornerRadius = 10
        userNameView.addInnerShadow()

        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.lightGray.cgColor
        passwordView.layer.cornerRadius = 10
        passwordView.addInnerShadow()

        setupTextField()
    }

    override func setupData() {
        super.setupData()
    }

    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onFailure: { [weak self] in
                guard let this = self else { return }
                this.navigationController?.present(UIAlertController.alertWithError($0), animated: true, completion: nil)
            })
            .store(in: &subscriptions)

        viewModel.isLoginSuccess
            .sink { [weak self] isSuccess in
                guard let this = self else { return }
                if isSuccess {
                    AppDelegate.shared.setRootViewController(root: .home)
                } else {
                    this.showAlert()
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - Privates
    private func setupTextField() {
        // Create publisher for textfield
        let userNameTextFieldPublisher = userNameTextField.textPublisher()
        let passwordTextFieldPublisher = passwordTextField.textPublisher()

        userNameTextFieldPublisher
            .combineLatest(passwordTextFieldPublisher)
            .map({ [weak self] (email, password) -> Bool in
                guard let this = self else { return false }
                return this.isValid(email: email, password: password)
            })
            .handleEvents(receiveOutput: { _ in
            })
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subscriptions)
    }

    private func isValid(email: String, password: String) -> Bool {
        return viewModel.isValidEmail(email) && viewModel.isValidPassword(password: password)
    }

    private func login(email: String, password: String) {
        viewModel.login(email: email, password: password)
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Email or password is not correct!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBAction
    @IBAction private func login(_ sender: Any?) {
        guard let email = userNameTextField.text, let password = passwordTextField.text else { return }
        login(email: email, password: password)
    }

    @IBAction private func register(_ sender: Any?) {
        let vc = RegisterViewController()
        let publisher = PassthroughSubject<(String, String), Never>()
        publisher.sink { email, password in
            self.login(email: email, password: password)
        }.store(in: &subscriptions)

        vc.viewModel = viewModel.viewModelForRegister(publisher: publisher)
        navigationController?.pushViewController(vc, animated: true)
    }
}

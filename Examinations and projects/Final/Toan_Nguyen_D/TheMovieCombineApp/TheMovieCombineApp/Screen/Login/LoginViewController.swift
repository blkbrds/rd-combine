//
//  LoginViewController.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 27/07/2021.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    private var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        validateInput()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setup() {
        loginButton.isEnabled = false
        usernameTextField.delegate = self
        usernameTextField.publisher(for: \.text)
            .receive(on: RunLoop.main)
            .assign(to: \.userName, on: viewModel)
            .store(in: &viewModel.subscriptions)
        passwordTextField.publisher(for: \.text)
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &viewModel.subscriptions)
    }

    private func validateInput() {
        viewModel.inputValidatePublisher.sink {[weak self] (validate) in
            switch validate {
            case .valid:
                self?.loginButton.isEnabled = true
                self?.loginButton.alpha = 1
            case .invalid:
                self?.loginButton.isEnabled = false
                self?.loginButton.alpha = 0.7
            }
        }.store(in: &viewModel.subscriptions)
    }

    @IBAction private func loginButtonTouchUpInside() {
        viewModel.login()
            .sink { (_) in
            } receiveValue: { () in
                AppDelegate.shared.changeRoot(rootType: .home)
            }.store(in: &viewModel.subscriptions)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.becomeFirstResponder()
        }
    return true
    }
}

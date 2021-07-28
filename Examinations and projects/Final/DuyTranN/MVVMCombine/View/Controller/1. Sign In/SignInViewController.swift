//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class SignInViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!

    // MARK: - Properties
    var viewModel = SignInViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - IBActions
    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        viewModel.tappedSignInButton()
    }
}

// MARK: - Extension SignInViewController
extension SignInViewController {

    // MARK: - Private functions
    private func handleSignIn() {
        AppDelegate.shared.changeRoot(to: .listNews)
    }

    private func configUI() {
        /// View `Gradient`
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [Colors.lightBlue.cgColor, Colors.lightGreen.cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)

        /// `Target`
        [userNameTextField, passwordTextField].forEach({
            $0.addTarget(self,
                         action: #selector(textFieldEditingChanged(textField:)),
                         for: .editingChanged)
        })

        /// `Tap gesture`
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped(_:)))
        view.addGestureRecognizer(tapGesture)

        /// `Button`
        updateSignInButton()
    }

    private func setupBinding() {
        viewModel.validationSubject
            .sink(receiveValue: { [weak self] value in
                guard let this = self else { return }
                this.updateSignInButton()

                if let userNameError = value.0 {
                    print("🧨", userNameError.message)
                    return
                }
                if let passwordError = value.1 {
                    print("🧨", passwordError.message)
                    return
                }
            })
            .store(in: &subscriptions)

        viewModel.loginProgressSubject
            .sink(receiveValue: { [weak self] isValid in
                guard let this = self else { return }
                guard isValid else { return }

                this.showHUD(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    this.showHUD(false)
                    this.handleSignIn()
                }
            })
            .store(in: &subscriptions)
    }

    private func updateSignInButton() {
        let value = viewModel.validationSubject.value
        let hasError = value.0 != nil || value.1 != nil
        if hasError {
            signInButton.alpha = 0.5
        } else {
            signInButton.alpha = 1
        }
        signInButton.isUserInteractionEnabled = !hasError
    }

    @objc private func textFieldEditingChanged(textField: UITextField) {
        switch textField {
        case userNameTextField:
            viewModel.userNameSubject.send(textField.value)
        case passwordTextField:
            viewModel.passwordSubject.send(textField.value)
        default:
            break
        }
    }

    @objc private func superViewTapped(_ gesture: UIGestureRecognizer) {
        [userNameTextField, passwordTextField].forEach({
            if $0!.isFirstResponder {
                $0?.resignFirstResponder()
            }
        })
    }
}

//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!

    // MARK: - Properties
    var viewModel = SignInViewModel()
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - IBActions
    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        viewModel.tappedSignInButton()
    }
}

extension SignInViewController {

    // MARK: - Private functions
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func configUI() {
        /// `Target`
        [userNameTextField, passwordTextField].forEach({
            $0.addTarget(self,
                         action: #selector(textFieldEditingChanged(textField:)),
                         for: .editingChanged)
        })

        /// `Binding`
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

        viewModel.checkDatabaseSubject
            .sink(receiveValue: { [weak self] isValid in
                guard let this = self else { return }
                guard isValid else {
                    print("🧨 Tài khoản ko có trong DB")
                    return
                }
                print("☘️ Đăng nhập thành công")
                this.indicatorView.startAnimating()
                this.indicatorView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    this.indicatorView.stopAnimating()
                    this.handleSignIn()
                }
            })
            .store(in: &subscriptions)

        /// `Navigation`
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()

        /// `Button`
        updateSignInButton()
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
}

extension UITextField {
    var value: String {
        guard let string = self.text else { return "" }
        return string
    }
}

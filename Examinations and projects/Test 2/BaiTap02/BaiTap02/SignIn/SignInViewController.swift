//
//  SignInViewController.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/13/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

class SignInViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var viewModel: SignInViewModel?
    var userNameValidate = CurrentValueSubject<Bool,Never>(false)
    var passwordValidate = CurrentValueSubject<Bool,Never>(false)
    var subcripstions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()

        let _ = userNameValidate
        .combineLatest(passwordValidate)
        .map {
            $0 && $1
        }
        .sink(receiveValue: { (isEnabled) in
            if isEnabled {
                self.signInButton.isEnabled = isEnabled
            } else {
                self.signInButton.isEnabled = isEnabled
            }
        })
        .store(in: &subcripstions)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func userNameEditingChanged(_ sender: Any) {
        guard let userName = userNameTextField.text else { return }
        isValidateUserName(userName: userName)
    }

    @IBAction func passwordEditingChanged(_ sender: Any) {
        guard let password = passwordTextField.text else { return }
        isValidatePassword(password: password)
    }

    @IBAction func signInTouchUpInside(_ sender: Any) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorView.stopAnimating()
            LocalDatabase.users.contains(where: { user -> Bool in
                user.name == self.userNameTextField.text && user.password == self.passwordTextField.text
            }) ? self.handleSignIn() : print("Đăng nhập không thành công")
        }
    }

    private func isValidateUserName(userName: String) {
        if userName.count < 2 || userName.count > 20 {
            print(SignInError.invalidUsernameLength.message)
            userNameValidate.send(false)
        } else if userName.containsEmoji {
            print(SignInError.invalidUsername.message)
            userNameValidate.send(false)
        } else {
            userNameValidate.send(true)
        }
    }

    private func isValidatePassword(password: String) {
        if password.count < 8 || password.count > 20 {
            print(SignInError.invalidPasswordLength.message)
            passwordValidate.send(false)
        } else {
            passwordValidate.send(true)
        }
    }

    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

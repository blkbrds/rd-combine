//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: SignInViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        signInButton.isEnabled = false
        setup()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }


    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        guard let userName = userNameTextField.text,
            let password = passwordTextField.text else { return }
        if LocalDatabase.users.contains(where: {$0.name == userName && $0.password == password}) {
            indicatorView.startAnimating()
            indicatorView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.indicatorView.stopAnimating()
                self.handleSignIn()
            }
        } else {
            print("Đăng nhập không thành công")
        }
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        let viewModel = HomeViewModel()
        viewModel.users = LocalDatabase.users
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }

    func setup() {
        guard let viewModel = viewModel else { return }
        viewModel.userNamesubject
            .filter({ (userName) -> Bool in
                let isValidUserName = !userName.containsEmoji
                let isValidUserNameLength = userName.count >= 2 && userName.count <= 20
                if !isValidUserName {
                    print(SignInError.invalidUsername.message)
                }
                if !isValidUserNameLength {
                    print(SignInError.invalidUsernameLength.message)
                }

                if !(isValidUserName && isValidUserNameLength) {
                    self.signInButton.isEnabled = false
                }
                return isValidUserName && isValidUserNameLength
            })
            .sink { (userName) in
                let password = self.passwordTextField.text ?? ""
                let isValidPassword = password.count >= 8 && password.count <= 20

                self.signInButton.isEnabled = isValidPassword
            }
            .store(in: &viewModel.subscription)

        viewModel.passwordSubject
            .filter({ (password) -> Bool in
                let isValidPassword = password.count >= 8 && password.count <= 20
                if !isValidPassword {
                    print(SignInError.invalidPasswordLength.message)
                }

                if !isValidPassword {
                    self.signInButton.isEnabled = false
                }
                return isValidPassword
            })
            .sink { (password) in
                let userName = self.userNameTextField.text ?? ""
                let isValidUserName = !userName.containsEmoji
                let isValidUserNameLength = userName.count >= 2 && userName.count <= 20

                self.signInButton.isEnabled = isValidUserName && isValidUserNameLength
            }
            .store(in: &viewModel.subscription)
    }

    func setupTextField() {
        userNameTextField.addTarget(self, action: #selector(userNameTextFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func userNameTextFieldDidChange(_ sender: Any?) {
        let text = userNameTextField.text ?? ""
        viewModel?.userNamesubject.send(text)
    }

    @objc func passwordTextFieldDidChange(_ sender: Any?) {
        let text = passwordTextField.text ?? ""
        viewModel?.passwordSubject.send(text)
    }
}

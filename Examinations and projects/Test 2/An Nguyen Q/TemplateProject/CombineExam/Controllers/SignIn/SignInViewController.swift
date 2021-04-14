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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: SignInViewModel?
    var isLoginSuccess: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
    }

    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorView.stopAnimating()
            self.handleSignIn()
        }
    }

    @IBAction func usernameEditingChange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            viewModel?.usernamePublisher.send(text)
            updateUISignButton(viewModel?.isValidateSuccess ?? false)
        }
    }

    @IBAction func passwordEditingChange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            viewModel?.passwordPublisher.send(text)
            updateUISignButton(viewModel?.isValidateSuccess ?? false)
        }
    }
    
    private func handleSignIn() {
        if let username = usernameTextField.text,
           let password = passwordTextField.text {
            for user in LocalDatabase.users {
                checkLoginSuccess(username: username, password: password, userLocal: user)
            }
            if !isLoginSuccess {
                print("Khong dang nhap thanh cong")
            }
        }
    }
    
    private func updateUISignButton(_ isActive: Bool) {
        signInButton.isEnabled = isActive
        signInButton.alpha = isActive ? 1 : 0.5
    }
    
    private func checkLoginSuccess(username: String, password: String, userLocal: User) {
        if username == userLocal.name,
           password == userLocal.password {
            let vc = HomeViewController()
            vc.viewModel = HomeViewModel()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
}


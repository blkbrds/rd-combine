//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    var viewModel = SignInViewModel()
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        emailTextField.publisher
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
        passwordTextField.publisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
        viewModel.isValidate?
            .assign(to: \.isEnabled, on: signInButton)
            .store(in: &subscriptions)
        emailTextField.publisher
            .sink { email in
                guard let email = email else { return }
                print(self.viewModel.valiDateEmail(email: email))
            }
            .store(in: &subscriptions)
        
        passwordTextField.publisher
            .sink { password in
                guard let password = password else { return }
                print(self.viewModel.valiDatePassword(password: password))
            }
            .store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }


    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorView.stopAnimating()
            self.handleSignIn()
        }
    }
    
    private func handleSignIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let users = LocalDatabase.users
        for item in users {
            if item.name == email && item.password == password {
                let vc = HomeViewController()
                vc.viewModel = HomeViewModel()
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        print("lỗi Đăng nhập không thành công")
    }
}

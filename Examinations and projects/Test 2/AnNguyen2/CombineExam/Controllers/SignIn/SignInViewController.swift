//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: SignInViewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        bindingData()
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
    
    private func bindingData() {
        usernameTextField.textPublisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subscriptions)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
                    
        usernameTextField.textPublisher
            .combineLatest(passwordTextField.textPublisher)
            .map({ _ in self.viewModel.validUsername && self.viewModel.validatedPassword })
            .assign(to: \.isEnabled, on: signInButton)
            .store(in: &subscriptions)
    }
    
    private func handleSignIn() {
        if viewModel.checkValidUser {
            let vc = HomeViewController()
            vc.viewModel = HomeViewModel()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Đăng nhập không thành công")
        }
    }
}

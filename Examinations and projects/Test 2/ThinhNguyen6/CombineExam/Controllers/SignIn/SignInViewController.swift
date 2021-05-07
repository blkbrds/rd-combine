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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: SignInViewModel = SignInViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        bindingToViewModel()
        viewModel.isValidate?.assign(to: \.isEnabled, on: signInButton).store(in: &subscriptions)
        
        usernameTextField.publisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subscriptions)
        
        passwordTextField.publisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
    }
    
    func checkEnable() {
        
        if viewModel.checkEnable(username: viewModel.username, password: viewModel.password) {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
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
    func bindingToViewModel() {
        usernameTextField.publisher
            .sink(receiveValue: { (username) in
                print(self.viewModel.validateUserName(username: username))
            })
            .store(in: &subscriptions)
        passwordTextField.publisher
            .sink(receiveValue: { (password) in
                print(self.viewModel.validatePassword(password: password))
            })
            .store(in: &subscriptions)
    }
 
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        guard let userName = usernameTextField.text, let password = passwordTextField.text else { return }
        LocalDatabase.users.contains { (user) -> Bool in
            user.name == userName  && user.password == password
        } ? navigationController?.pushViewController(vc, animated: true): print ("Đăng nhập không thành công")
    }
}


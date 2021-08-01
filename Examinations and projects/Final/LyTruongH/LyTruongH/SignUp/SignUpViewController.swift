//
//  SignInViewController.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {

    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel = SignUpViewModel()
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        passWordTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        viewModel.isValid?
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellables)
        userNameTextField.publisherCustom
            .debounce(for: .milliseconds(3000), scheduler: RunLoop.main)
            .sink { email in
                guard let email = email else { return }
                if !self.viewModel.validateEmail(email) {
                    print("email Wrong")
                }
            }
            .store(in: &cancellables)
    }

    @objc func textFieldDidChange(textField: UITextField) {
        switch textField {
        case userNameTextField:
            viewModel.username = textField.text ?? ""
        default:
            viewModel.password = textField.text ?? ""
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

    @IBAction func signUp(_ sender: Any) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorView.stopAnimating()
            self.handleSignIn()
        }
    }
    
    private func handleSignIn() {
        guard let email = userNameTextField.text, let password = passWordTextField.text else { return }
        let user = User(name: email, address: "", password: password)
        LocalDatabase.users.append(user)
        navigationController?.popToRootViewController(animated: true)
    }
}


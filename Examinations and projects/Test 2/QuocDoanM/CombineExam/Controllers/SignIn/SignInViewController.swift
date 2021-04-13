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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: SignInViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private var isValidateUserName: Bool = false
    private var isValidatePassword: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        passwordTextField.delegate = self
        userNameTextField.delegate = self
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
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func enableSignInButton() {
        signInButton.isEnabled = isValidatePassword && isValidateUserName
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case userNameTextField:
            if #available(iOS 14.0, *) {
                let userNamePublisher: PassthroughSubject<String, SignInError> = PassthroughSubject<String, SignInError>()
                userNamePublisher
                    .sink { completion in
                        print("Completion: ", completion)
                    } receiveValue: { value in
                        if (value.count >= 2 && value.count <= 20) && !value.containsEmoji {
                            self.isValidateUserName = true
                            
                        } else {
                            self.isValidateUserName = false
                        }
                    }
                    .store(in: &subscriptions)
                userNamePublisher.send(userNameTextField.text ?? "")
            } else {
                // Fallback on earlier versions
            }
        default:
            if #available(iOS 14.0, *) {
                let passwordPublisher: PassthroughSubject<String, SignInError> = PassthroughSubject<String, SignInError>()
                passwordPublisher
                    .sink { completion in
                        print("Completion: ", completion)
                    } receiveValue: { value in
                        if (value.count >= 8 && value.count <= 20) {
                            self.isValidatePassword = true
                        } else {
                            self.isValidatePassword = false
                        }
                    }
                    .store(in: &subscriptions)
                passwordPublisher.send(passwordTextField.text ?? "")
            } else {
                // Fallback on earlier versions
            }
        }
        enableSignInButton()
    }
}

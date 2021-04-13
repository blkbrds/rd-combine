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
    
    var viewModel: SignInViewModel?
    var subscriptions = Set<AnyCancellable>()
    let usernamePublisher = PassthroughSubject<String, SignInError>()
    let passwordPublisher = PassthroughSubject<String, SignInError>()
    var isValidateUser: Bool = false
    var isValidatePW: Bool = false


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
        
        usernamePublisher.sink(receiveCompletion: {
            if $0 == .failure(SignInError.invalidUserName) {
                print(SignInError.invalidUserName.message)
            }
        }, receiveValue: { print("Username", $0) })
        .store(in: &subscriptions)
        
        passwordPublisher.sink(receiveCompletion: {
            if $0 == .failure(SignInError.invalidPassword) {
                print(SignInError.invalidUserName.message)
            }
        }, receiveValue: { print("Password", $0) })
        .store(in: &subscriptions)
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
        if let text = sender.text {
            validateUsername(text: text)
        }
    }

    @IBAction func passwordEditingChange(_ sender: UITextField) {
    }
    
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateUsername(text: String) {
        if text.count >= 2,
           text.count <= 20, !text.containsEmoji {
            usernamePublisher.send(text)
        } else {
            usernamePublisher.send(completion: .failure(SignInError.invalidUserName))
        }
    }
    
    func validatePassword(text: String) {
        if text.count >= 8,
           text.count <= 20, !text.containsEmoji {
            usernamePublisher.send(text)
        } else {
            usernamePublisher.send(completion: .failure(SignInError.invalidUserName))
        }
    }
}

extension SignInViewController {
    enum SignInError: Error {
        case invalidUserName
        case invalidPassword
        
        var message: String {
            switch self {
            case .invalidUserName:
                return "Username is Invalid"
            case .invalidPassword:
                return "Password is Invalid"
            }
        }
    }
}

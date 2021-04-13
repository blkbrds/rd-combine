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

    var isEnableName: Bool = false
    var isEnablePw: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        signInButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }


    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        let correctUser = LocalDatabase.users.first(where: { $0.name == viewModel?.username && $0.password == viewModel?.password })
        if let _ = correctUser {
            indicatorView.startAnimating()
            indicatorView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.indicatorView.stopAnimating()
                self.handleSignIn()
                self.viewModel?.username = ""
                self.viewModel?.password = ""
            }
        } else {
            print("Đăng nhập không thành công")
        }
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            let subject = PassthroughSubject<String, SignInError>()
            subject
                .sink { (completion) in
                    print(completion)
                } receiveValue: { name in
                    self.viewModel?.username = name
                    if name.count >= 2 && name.count <= 20 && !name.containsEmoji {
                        self.isEnableName = true
                        self.signInButton.isEnabled = self.isEnableName && self.isEnablePw
                    } else {
                        if name.count < 2 || name.count > 20 {
                            subject.send(completion: .failure(.invalidUsernameLength))
                        }
                        if name.containsEmoji {
                            subject.send(completion: .failure(.invalidUsername))
                        }
                        self.isEnableName = false
                        self.signInButton.isEnabled = false
                    }
                }
                .store(in: &subscriptions)
            subject.send(textField.text ?? "")
        case passwordTextField:
            let subject = PassthroughSubject<String, SignInError>()
            subject
                .sink { (completion) in
                    print(completion)
                } receiveValue: { pw in
                    self.viewModel?.password = pw
                    if pw.count >= 8 && pw.count <= 20 {
                        self.isEnablePw = true
                        self.signInButton.isEnabled = self.isEnableName && self.isEnablePw
                    } else {
                        if pw.count < 8 || pw.count > 20 {
                            subject.send(completion: .failure(.invalidPasswordLength))
                        }
                        self.isEnablePw = false
                        self.signInButton.isEnabled = false
                    }
                }
                .store(in: &subscriptions)
            subject.send(textField.text ?? "")
        default: break
        }
    }
}

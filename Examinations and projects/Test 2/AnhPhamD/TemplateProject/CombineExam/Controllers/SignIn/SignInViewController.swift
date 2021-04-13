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
    @IBOutlet weak var passWordTextField: UITextField!
    
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
        configSignInButton()
        configTextField()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func configSignInButton() {
        guard let viewModel = viewModel else { return }
        viewModel.userNameSubject
            .map { (userName) in
                if userName.count > 2 && userName.count < 20 {
                    return true
                } else {
                    return false
                }
            }
            .sink { (value) in
                self.signInButton.isEnabled = value
            }
            .store(in: &viewModel.subcriptions)
        viewModel.passWordSubject
            .map { (passWord) in
                if passWord.count > 8 && passWord.count < 20 {
                    return true
                } else {
                    return false
                }
            }
            .sink { (value) in
                self.signInButton.isEnabled = value
            }
            .store(in: &viewModel.subcriptions)
    }

    func configTextField() {
        userNameTextField.addTarget(self, action: #selector(userNameDidChange), for: .editingChanged)
        passWordTextField.addTarget(self, action: #selector(passWordDidChange), for: .editingChanged)
    }

    @objc func userNameDidChange() {
        guard let viewModel = viewModel, let userName = userNameTextField.text else { return }
        viewModel.userNameSubject.send(userName)
    }

    @objc func passWordDidChange() {
        guard let viewModel = viewModel, let passWord = passWordTextField.text else { return }
        viewModel.passWordSubject.send(passWord)
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
}

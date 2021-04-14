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
    
    private let viewModel: SignInViewModel = SignInViewModel()
    private var bindings = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setUpBindings() {
        func bindViewToViewModel() {
            userNameTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.email, on: viewModel)
                .store(in: &bindings)

            userNameTextField.textPublisher
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    if value.containsEmoji {
                        print(SignInError.invalidUsername.message)
                    } else if value.count < 2 || value.count > 20 {
                        print(SignInError.invalidUsernameLength.message)
                    }
                })
                .store(in: &bindings)

            passwordTextField.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)

            passwordTextField.textPublisher
                .sink(receiveCompletion: { _ in }, receiveValue: { value in
                    if value.count < 8 || value.count > 20 {
                        print(SignInError.invalidPasswordLength.message)
                    }
                })
                .store(in: &bindings)
        }

        func bindViewModelToView() {
            viewModel.isInputValid
                .receive(on: RunLoop.main)
                .assign(to: \.isValid, on: signInButton)
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        if viewModel.isValidUser() {
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
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

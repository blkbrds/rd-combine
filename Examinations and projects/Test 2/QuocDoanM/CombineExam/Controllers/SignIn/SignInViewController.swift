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
    
    var viewModel: SignInViewModel = SignInViewModel()
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

        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupBindings() {
        userNameTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.userName, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)

        viewModel.readyToSubmit
            .map { $0 != nil}
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isEnable in
                self.signInButton.isEnabled = isEnable
            })
            .store(in: &subscriptions)
    }

    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        viewModel.enableSignInButton(userNameTextField.text ?? "", passwordTextField.text ?? "") { isAvailable in
            isAvailable ? self.handleSignIn() : print("Loi")
        }
    }
    
    private func handleSignIn() {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorView.stopAnimating()
            let vc = HomeViewController()
            vc.viewModel = HomeViewModel()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

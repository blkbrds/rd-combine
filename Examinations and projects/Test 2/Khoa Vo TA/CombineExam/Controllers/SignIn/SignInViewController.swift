//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    var subscriptions = Set<AnyCancellable>()

    var viewModel = SignInViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private
    private func bindViewModel() {
        viewModel.validationState
            .sink { validationState in
                switch validationState {
                case .failed(let signInError):
                    print(signInError.message)
                }
            }.store(in: &subscriptions)
        viewModel.isValidate?
            .assign(to: \.isEnabled, on: signInButton)
            .store(in: &subscriptions)
        emailTextField.publisher
            .assign(to: \.emailText, on: viewModel)
            .store(in: &subscriptions)
        passwordTextField.publisher
            .assign(to: \.passwordText, on: viewModel)
            .store(in: &subscriptions)
        viewModel.$emailText
            .sink { [weak self] email in
                guard let this = self else { return }
                this.viewModel.validateEmail()
            }.store(in: &subscriptions)
        viewModel.$passwordText
            .sink { [weak self] email in
                guard let this = self else { return }
                this.viewModel.validatePassword()
            }.store(in: &subscriptions)
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let this = self else { return }
            this.indicatorView.stopAnimating()
            if this.viewModel.isExistUser {
                this.handleSignIn()
            } else {
                print("Email va password khong ton tai trong DB")
            }
        }
    }
}

extension UITextField {
    var publisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField? }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}

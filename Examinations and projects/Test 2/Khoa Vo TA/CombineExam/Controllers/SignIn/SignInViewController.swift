//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class SignInViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel = SignInViewModel()

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
    
    private func bindViewModel() {
        viewModel.signInState
            .sink { [weak self] signInState in
                guard let this = self else { return }
                switch signInState {
                case .valid:
                    this.indicatorView.startAnimating()
                    this.indicatorView.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        this.indicatorView.stopAnimating()
                        this.handleSignIn()
                    }
                case .failed(let signInError):
                    print(signInError.message)
                case .validateFailed(let signInError):
                    print(signInError.message)
                }
            }.store(in: &subscriptions)
        viewModel.isLoginValid?
                   .assign(to: \.isEnabled, on: signInButton)
                   .store(in: &subscriptions)
        emailTextField.publisher
            .assign(to: \.emailText, on: viewModel)
            .store(in: &subscriptions)
        passwordTextField.publisher
            .assign(to: \.passwordText, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        self.viewModel.action.send(.validate)
    }
}

extension UITextField {
    var publisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap {
                $0.object as? UITextField?
            }
            .map { ($0?.text ?? "") }
            .eraseToAnyPublisher()
    }
}

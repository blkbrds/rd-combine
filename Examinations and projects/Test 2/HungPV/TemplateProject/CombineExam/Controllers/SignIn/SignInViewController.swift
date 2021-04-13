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
    private var subcripstions: Set<AnyCancellable> = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()

        usernameTextField.textPublisher
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] text in
                if text.count < 2 || text.count > 20 {
                    print(SignInError.invalidUsernameLength.message)
                } else if text.containsEmoji {
                    print(SignInError.invalidUsername.message)
                } else {
                    guard let this = self else { return }
                    this.viewModel.usernameValidate.send(true)
                }
            })
            .store(in: &subcripstions)

        passwordTextField.textPublisher
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] pwText in
                guard let this = self else { return }
                if pwText.count < 8 || pwText.count > 20 {
                    print(SignInError.invalidPasswordLength.message)
                } else if pwText.count > 8 || pwText.count < 20 {
                    this.viewModel.passwordValidate.send(true)
                    this.viewModel.passwordText.send(pwText)
                } else {
                    print(SignInError.unknown.message)
                }
            })
            .store(in: &subcripstions)

        let _ = viewModel.usernameValidate
            .combineLatest(viewModel.passwordValidate)
            .map {
                $0 == true && $1 == true
            }
            .sink(receiveValue: { (bool) in
                if bool {
                    self.signInButton.isEnabled = true
                } else {
                    self.signInButton.isEnabled = false
                }
            })
            .store(in: &subcripstions)
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
            if LocalDatabase.users.contains(where: {
                $0.address == self.viewModel.passwordText.value
            }) {
                self.handleSignIn()
            } else {
                print("Đăng nhập không thành công")
            }
        }
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

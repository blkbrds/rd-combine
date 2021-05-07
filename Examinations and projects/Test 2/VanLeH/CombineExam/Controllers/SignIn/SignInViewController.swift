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
    
    var viewModel: SignInViewModel = SignInViewModel()

    private var subscriptions = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func binding() {
        viewModel.usernameError
            .dropFirst()
            .sink {
                guard let message = $0?.message else { return }
                print(message)
            }
            .store(in: &subscriptions)

        viewModel.passwordError
            .dropFirst()
            .sink {
                guard let message = $0?.message else { return }
                print(message)
            }
            .store(in: &subscriptions)

        viewModel.usernameError
            .combineLatest(viewModel.passwordError)
            .dropFirst()
            .sink { _ in } receiveValue: { [weak self] in
                self?.signInButton.isEnabled = ($0.0 == nil) && ($0.1 == nil)
            }
            .store(in: &subscriptions)
    }

    @IBAction func usernameTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.usernameSubject.send(sender.text)
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.passwordSubject.send(sender.text)
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
        guard let username = viewModel.usernameSubject.value,
              let password = viewModel.passwordSubject.value,
              LocalDatabase.users.contains(where: { $0.name == username && $0.password == password })
        else {
            print("Đăng nhập không thành công")
            return
        }
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

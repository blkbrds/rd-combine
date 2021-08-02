//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class SignInViewController: ViewController {
    
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var userNameErrorLabel: UILabel!
    @IBOutlet private weak var passWordErrorLabel: UILabel!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passWordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    var viewModel: SignInViewModel = SignInViewModel()
    
    override func binding() {
        bindingView()
        bindingViewModel()
    }
    
    private func bindingView() {
        signInButton.publisher(for: .touchUpInside).sink { [weak self] (_) in
            guard let this = self else { return }
            this.indicatorView.startAnimating()
            this.indicatorView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                this.indicatorView.stopAnimating()
                this.handleSignIn()
            }
        }.store(in: &subscriptions)
        
        signUpButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let this = self else { return }
            let vc = SignUpViewController()
            this.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &subscriptions)
        
        userNameTextField.publisher(for: .editingChanged).sink { [weak self] _ in
            guard let this = self else { return }
            this.viewModel.usernameSubject.send(this.userNameTextField.text)
        }.store(in: &subscriptions)
        
        passWordTextField.publisher(for: .editingChanged).sink { [weak self] _ in
            guard let this = self else { return }
            this.viewModel.passwordSubject.send(this.passWordTextField.text)
        }.store(in: &subscriptions)
    }
    
    private func bindingViewModel() {
        viewModel.usernameError
            .dropFirst()
            .sink { [weak self] in
                guard let message = $0?.message else {
                    self?.userNameErrorLabel.isHidden = true
                    return
                }
                self?.userNameErrorLabel.isHidden = false
                self?.userNameErrorLabel.text = message
            }
            .store(in: &subscriptions)

        viewModel.passwordError
            .dropFirst()
            .sink { [weak self] in
                guard let message = $0?.message else {
                    self?.passWordErrorLabel.isHidden = true
                    return
                }
                self?.passWordErrorLabel.isHidden = false
                self?.passWordErrorLabel.text = message
            }
            .store(in: &subscriptions)

        viewModel.usernameError
            .combineLatest(viewModel.passwordError)
            .sink { _ in } receiveValue: { [weak self] in
                self?.signInButton.isEnabled = ($0.0 == nil)
                    && ($0.1 == nil)
            }
            .store(in: &subscriptions)
    }
    
    private func handleSignIn() {
        guard let username = viewModel.usernameSubject.value,
              let password = viewModel.passwordSubject.value,
              Session.shared.userLogin.contains(User(name: username, password: password))
        else {
            alert(message: "Tên đăng nhập hoặc mật khẩu không chính xác !!!")
            return
        }
        Session.shared.isLogged = true
        
        var listUser = Session.shared.userLogin
        
        if !listUser.contains(User(name: username, password: password)) {
            listUser.append(User(name: username, password: password))
        }
        
        Session.shared.userLogin = listUser
        SceneDelegate.shared.setRoot(type: .main)
    }
}

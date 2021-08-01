//
//  SignUpViewController.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/29/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class SignUpViewController: ViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var userNameErrorLabel: UILabel!
    @IBOutlet weak var passWordErrorLabel: UILabel!
    @IBOutlet weak var resubmitPassWordErrorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var resubmitPassWordTextField: UITextField!
    
    var viewModel: SignUpViewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func binding() {
        bindingView()
        bindingViewModel()
    }
    
    private func bindingViewModel() {
        viewModel.usernameError
            .dropFirst()
            .sink { [weak self] in
                guard let message = $0?.message else {
                    self?.userNameErrorLabel.isHidden = true
                    self?.toggleSignUpButton()
                    return
                }
                self?.userNameErrorLabel.isHidden = false
                self?.userNameErrorLabel.text = message
                self?.toggleSignUpButton()
            }
            .store(in: &subscriptions)

        viewModel.passwordError
            .dropFirst()
            .sink { [weak self] in
                guard let message = $0?.message else {
                    self?.passWordErrorLabel.isHidden = true
                    self?.toggleSignUpButton()
                    return
                }
                self?.passWordErrorLabel.isHidden = false
                self?.passWordErrorLabel.text = message
                self?.toggleSignUpButton()
            }
            .store(in: &subscriptions)
        
        viewModel.resubmitPassWordError
            .dropFirst()
            .sink { [weak self] in
                guard let message = $0?.message else {
                    self?.resubmitPassWordErrorLabel.isHidden = true
                    self?.toggleSignUpButton()
                    return
                }
                self?.resubmitPassWordErrorLabel.isHidden = false
                self?.resubmitPassWordErrorLabel.text = message
                self?.toggleSignUpButton()
            }
            .store(in: &subscriptions)
    }
    
    private func bindingView() {
        userNameTextField.publisher(for: .editingChanged).sink { [weak self] _ in
            self?.viewModel.usernameSubject.send(self?.userNameTextField.text)
        }.store(in: &subscriptions)
        
        passWordTextField.publisher(for: .editingChanged).sink { [weak self] _ in
            self?.viewModel.passwordSubject.send(self?.passWordTextField.text)
        }.store(in: &subscriptions)
        
        resubmitPassWordTextField.publisher(for: .editingChanged).sink { [weak self] _ in
            self?.viewModel.resubmitPasswordSubject.send(self?.resubmitPassWordTextField.text)
        }.store(in: &subscriptions)
        
        signUpButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            self?.handleSignUp()
        }.store(in: &subscriptions)
    }
    
    private func toggleSignUpButton() {
        signUpButton.isEnabled = userNameErrorLabel.isHidden
            && passWordErrorLabel.isHidden
            && resubmitPassWordErrorLabel.isHidden
    }
        
   private func handleSignUp() {
        guard let username = viewModel.usernameSubject.value,
              let password = viewModel.passwordSubject.value
        else {
            alert(message: "Đăng ký không thành công !!!")
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

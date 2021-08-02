//
//  LoginViewController.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

class LoginViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - Properties
    var viewModel: LoginViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let viewModelInput = LoginViewModel.Input(
            username: userNameTextField.textPublisher,
            password: passwordTextField.textPublisher,
            doLogin: loginButton.tapPublisher,
            doRegister: registerButton.tapPublisher
        )

        let viewModelOutput = viewModel?.transform(viewModelInput)

        viewModelOutput?.enableLogin.prepend(false)
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
    }
}

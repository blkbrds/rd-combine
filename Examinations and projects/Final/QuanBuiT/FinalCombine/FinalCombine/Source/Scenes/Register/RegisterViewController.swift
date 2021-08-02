//
//  RegisterViewController.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Combine

final class RegisterViewController: UIViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var accountTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var comfirmPaswordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    var viewModel: RegisterViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let viewModelInput = RegisterViewModel.Input(
            username: accountTextField.textPublisher,
            password: passwordTextField.textPublisher,
            doRegister: registerButton.tapPublisher,
            doCancel: cancelButton.tapPublisher
        )

        let viewModelOutput = viewModel?.transform(viewModelInput)

        viewModelOutput?.enableRegister.prepend(false)
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: registerButton)
            .store(in: &cancellables)
    }
}

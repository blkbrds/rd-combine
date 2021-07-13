//
//  LoginViewController.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var validateUsernameLabel: UILabel!
    @IBOutlet private weak var validatePasswordLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        // Do any additional setup after loading the view.
        configUI()
        bindingViewModel()
    }
    
    private func configUI() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.clear.cgColor
        
        validateUsernameLabel.textColor = .red
        validateUsernameLabel.font = UIFont.systemFont(ofSize: 12)
        
        validatePasswordLabel.textColor = .red
        validatePasswordLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    private func bindingViewModel() {
        userNameTextField.publisher(for: .editingChanged)
            .receive(on: DispatchQueue.main)
            .compactMap({ $0.text ?? "" })
            .assign(to: \.username.value, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.publisher(for: .editingChanged)
            .map({ _ in self.passwordTextField.text ?? "" })
            .assign(to: \.password.value, on: viewModel)
            .store(in: &subscriptions)

        validate()
        
        loginButton.publisher(for: .touchUpInside)
            .sink { button in
//                self.validateUsernameLabel.isHidden = self.viewModel.username.value.isEmpty
//                self.validatePasswordLabel.isHidden = self.viewModel.password.value.isEmpty
            }
            .store(in: &subscriptions)
//        loginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
    }
    
    private func validate() {
        // validate username
        viewModel.validateUserNamePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { [weak self] completionUsername in
                guard let this = self else { return }
                switch completionUsername {
                case .success:
                    print("Value username: success")
                    break
                case .failure(let error):
                    print("=====>error username:", error.message)
                    this.validateUsernameLabel.text = error.message
                }

                this.validateUsernameLabel.isHidden = completionUsername == .success
            }
            .store(in: &subscriptions)
        
        // validate password
        viewModel.validatePasswordPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { [weak self] completionPassword in
                guard let this = self else { return }
                
                switch completionPassword {
                case .success:
                    print("Value password: success")
                    break
                case .failure(let error):
                    print("=====>error password:", error.message)
                    this.validatePasswordLabel.text = error.message
                }
                this.validatePasswordLabel.isHidden = completionPassword == .success
            }
            .store(in: &subscriptions)
        
        // enable login button
        viewModel.validateUserNamePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .combineLatest(viewModel.validatePasswordPublisher)
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { [weak self] completionUsername, completionPassword in
                guard let this = self else { return }
                let isValidateSuccess = completionUsername == .success && completionPassword == .success
                
                this.loginButton.isEnabled = isValidateSuccess
                this.loginButton.alpha = isValidateSuccess ? 1 : 0.5
            }
            .store(in: &subscriptions)
    }
}

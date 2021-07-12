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
    }
    
    private func bindingViewModel() {
        userNameTextField.publisher
            .assign(to: \.username.value, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.publisher
            .assign(to: \.password.value, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.username.combineLatest(viewModel.password)
            .sink { [weak self] username, password in
                guard let this = self else {
                    return
                }
                this.loginButton.isEnabled = !username.isEmpty && !password.isEmpty
                this.loginButton.alpha = (username.isEmpty || password.isEmpty) ? 0.5 : 1
            }
            .store(in: &subscriptions)
        
        viewModel.validateUserNamePublisher
            .combineLatest(viewModel.validatePasswordPublisher)
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { completionUsername, completionPassword in
                switch completionUsername {
                case .success:
                    print("Value username: success")
                    self.validateUsernameLabel.text = ""
                case .failure(let error):
                    print("=====>error username:", error.message)
                    self.validateUsernameLabel.text = error.message
                }
                
                switch completionPassword {
                case .success:
                    print("Value password: success")
                    self.validatePasswordLabel.text = ""
                case .failure(let error):
                    print("=====>error password:", error.message)
                    self.validatePasswordLabel.text = error.message
                }
            }
            .store(in: &subscriptions)
        
        loginButton.publisher
            .sink { print("====Button tap:", $0) }
            .store(in: &subscriptions)
    }
//    
//    @IBAction func loginButtonTouchUpInside(_ sender: UIButton) {
//        
//    }
    
    @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
    }
    
    private func validate() {
    }
}

//
//  RegisterViewController.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/13/21.
//

import UIKit
import Combine
import FirebaseAuth

final class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var validateUsernameLabel: UILabel!
    @IBOutlet private weak var validatePasswordLabel: UILabel!
    @IBOutlet private weak var validateConfirmPasswordLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let viewModel = RegisterViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        // Do any additional setup after loading the view.
        configUI()
        bindingViewModel()
    }
    
    // MARK: - Private func
    private func configUI() {
        registerButton.isEnabled = false
        registerButton.alpha = 0.5
        registerButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderColor = UIColor.clear.cgColor
        
        validateUsernameLabel.textColor = .red
        validateUsernameLabel.font = UIFont.systemFont(ofSize: 12)
        
        validatePasswordLabel.textColor = .red
        validatePasswordLabel.font = UIFont.systemFont(ofSize: 12)
        
        validateConfirmPasswordLabel.textColor = .red
        validateConfirmPasswordLabel.font = UIFont.systemFont(ofSize: 12)
        indicator.isHidden = true
    }
    
    private func bindingViewModel() {
        usernameTextField.publisher(for: .editingChanged)
            .receive(on: DispatchQueue.main)
            .map({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.username.value, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.publisher(for: .editingChanged)
            .map({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.password.value, on: viewModel)
            .store(in: &subscriptions)
        
        confirmPasswordTextField.publisher(for: .editingChanged)
            .compactMap({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.confirmPassword.value, on: viewModel)
            .store(in: &subscriptions)

        validate()
        
        registerButton.publisher(for: .touchUpInside)
            .sink { _ in
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                self.registerUser()
            }
            .store(in: &subscriptions)

        loginButton.publisher(for: .touchUpInside)
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &subscriptions)
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
        
        // validate password
        viewModel.validateConfirmPasswordPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { [weak self] completionConfirmPassword in
                guard let this = self else { return }
                
                switch completionConfirmPassword {
                case .success:
                    print("Value password: success")
                    break
                case .failure(let error):
                    print("=====>error password:", error.message)
                    this.validateConfirmPasswordLabel.text = error.message
                }
                this.validateConfirmPasswordLabel.isHidden = completionConfirmPassword == .success
            }
            .store(in: &subscriptions)
        
        // enable login button
        viewModel.validateUserNamePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .combineLatest(viewModel.validatePasswordPublisher, viewModel.validateConfirmPasswordPublisher)
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { [weak self] completionUsername, completionPassword, completionConfirmPassword in
                guard let this = self else { return }
                let isValidateSuccess = completionUsername == .success && completionPassword == .success && completionConfirmPassword == .success
                
                this.registerButton.isEnabled = isValidateSuccess
                this.registerButton.alpha = isValidateSuccess ? 1 : 0.5
            }
            .store(in: &subscriptions)
    }
    
    private func registerUser() {
        Auth.auth().createUser(withEmail: viewModel.username.value, password: viewModel.password.value) { [weak self] result, err in
            guard let this = self else { return }
            this.indicator.isHidden = true
            this.indicator.stopAnimating()
            if let error = err {
                this.showError(error.localizedDescription)
                return
            }
            
            if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.changeRoot()
            }
        }
    }
}

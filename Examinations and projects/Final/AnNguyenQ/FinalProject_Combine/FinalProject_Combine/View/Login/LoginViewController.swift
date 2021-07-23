//
//  LoginViewController.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

import UIKit
import Combine
import FirebaseAuth

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var validateUsernameLabel: UILabel!
    @IBOutlet private weak var validatePasswordLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var viewModel: LoginViewModel = LoginViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        // Do any additional setup after loading the view.
        configUI()
        bindingViewModel()
    }
    
    // MARK: - Private funcs
    private func configUI() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.clear.cgColor
        registerButton.underline()
        
        validateUsernameLabel.textColor = .red
        validateUsernameLabel.font = UIFont.systemFont(ofSize: 12)
        
        validatePasswordLabel.textColor = .red
        validatePasswordLabel.font = UIFont.systemFont(ofSize: 12)
        indicator.isHidden = true
    }
    
    private func bindingViewModel() {
        userNameTextField.publisher(for: .editingChanged)
            .receive(on: DispatchQueue.main)
            .compactMap({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.username.value, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.publisher(for: .editingChanged)
            .compactMap({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.password.value, on: viewModel)
            .store(in: &subscriptions)

        validate()
        
        loginButton.publisher(for: .touchUpInside)
            .sink { button in
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                self.loginUser()
            }
            .store(in: &subscriptions)
//        loginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: viewModel.username.value, password: viewModel.password.value) { [weak self] result, error in
            guard let this = self else { return }
            this.indicator.isHidden = true
            this.indicator.stopAnimating()
            if let error = error {
                this.showError(error.localizedDescription)
                return
            }
            
            if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.changeRoot()
            }
        }
    }
}

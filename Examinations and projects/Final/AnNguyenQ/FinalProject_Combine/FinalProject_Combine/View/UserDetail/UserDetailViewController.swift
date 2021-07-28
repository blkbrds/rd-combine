//
//  UserDetailViewController.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/23/21.
//

import UIKit
import FirebaseAuth
import Combine

final class UserDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailValidateLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidateLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!
    
    // MARK: - Properties
    let viewModel = UserDetailViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editUserProfile))
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItems = [editButton, backButton]
        
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelUpdateUserProfile))
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem?.isEnabled = false

        configUI()
        bindingViewModel()
    }
    
    // MARK: - Private funcs
    private func bindingViewModel() {
        emailTextField.publisher(for: .editingChanged)
            .receive(on: DispatchQueue.main)
            .compactMap({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.username.value, on: viewModel)
            .store(in: &subscriptions)

        passwordTextField.publisher(for: .editingChanged)
            .compactMap({ $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" })
            .assign(to: \.password.value, on: viewModel)
            .store(in: &subscriptions)

        validate()
        
        updateButton.publisher(for: .touchUpInside)
            .sink { button in
                try? self.updateUserProfile()
            }
            .store(in: &subscriptions)
    }
    
    private func configUI() {
        stackView.isHidden = true
        getUserInfo()
        
        updateButton.alpha = 0.5
        updateButton.isEnabled = false
        
        emailValidateLabel.textColor = .red
        emailValidateLabel.font = UIFont.systemFont(ofSize: 12)
        
        passwordValidateLabel.textColor = .red
        passwordValidateLabel.font = UIFont.systemFont(ofSize: 12)
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    private func getUserInfo() {
        if let user = Auth.auth().currentUser {
            emailLabel.text = user.email
//            let changeProfile = user.createProfileChangeRequest()
//            changeProfile.displayName = "ABC"
//            changeProfile.commitChanges { error in
//                if let error = error {
//                    self.showError(error.localizedDescription)
//                }
//            }
            emailTextField.text = user.email
        }
    }
    
    private func validate() {
        // validate username
        viewModel.validateUserNamePublisher
            .receive(on: DispatchQueue.main)
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
                    this.emailValidateLabel.text = error.message
                }

                this.emailValidateLabel.isHidden = completionUsername == .success
            }
            .store(in: &subscriptions)
        
        // validate password
        viewModel.validatePasswordPublisher
            .receive(on: DispatchQueue.main)
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
                    this.passwordValidateLabel.text = error.message
                }
                this.passwordValidateLabel.isHidden = completionPassword == .success
            }
            .store(in: &subscriptions)
        
        // enable login button
        viewModel.validateUserNamePublisher
            .receive(on: DispatchQueue.main)
            .combineLatest(viewModel.validatePasswordPublisher)
            .sink { completion in
                print("=====>Completed:", completion)
            } receiveValue: { [weak self] completionUsername, completionPassword in
                guard let this = self else { return }
                let isValidateSuccess = completionUsername == .success && completionPassword == .success && (!this.viewModel.username.value.isEmpty || !this.viewModel.password.value.isEmpty)
                
                this.updateButton.isEnabled = isValidateSuccess
                this.updateButton.alpha = isValidateSuccess ? 1 : 0.5
            }
            .store(in: &subscriptions)
    }
    
    private func updateUserProfile() throws {
        if !viewModel.username.value.isEmpty {
            Auth.auth().currentUser?.updateEmail(to: viewModel.username.value, completion: { error in
                if let err = error {
                    self.showError(err.localizedDescription)
                }
            })
        }
        
        if !viewModel.password.value.isEmpty {
            Auth.auth().currentUser?.updatePassword(to: viewModel.password.value, completion: { error in
                if let err = error {
                    self.showError(err.localizedDescription)
                }
            })
        }
        
        showError("Update User Profile Success!") {
            self.getUserInfo()
            self.cancelUpdateUserProfile()
        }
    }
    
    @objc private func editUserProfile() {
        emailLabel.isHidden = true
        stackView.isHidden = false
        navigationItem.leftBarButtonItems?[0].isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc private func cancelUpdateUserProfile() {
        emailLabel.isHidden = false
        stackView.isHidden = true
        navigationItem.leftBarButtonItems?[0].isEnabled = true
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
}

//
//  SignInVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import UIKit
import Combine

final class SignInVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    var viewModel = SignInViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stores.removeAll()
    }

    // MARK: - Private functions
    private func setupBindings() {
        func bindingToView() {
            userNameTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.username, on: viewModel)
                .store(in: &viewModel.stores)

            pwTextField.publisher(for: .editingChanged)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.text }
                .assign(to: \.password, on: viewModel)
                .store(in: &viewModel.stores)

            signInButton.publisher(for: .touchUpInside)
                .flatMap { bt -> Just<Bool> in
                    let name = self.userNameTextField.text ?? ""
                    let pw = self.pwTextField.text ?? ""

                    let isExist = self.viewModel.users.contains { $0.userName == name && $0.password == pw }
                    return Just(isExist)
                }
                .sink { isExist in
                    if isExist {
                        self.handleSignIn()
                    } else {
                        print("No exist")
                    }
                }
                .store(in: &viewModel.stores)

        }

        func bindViewModelToView() {
            viewModel.isInputValid.compactMap({ $0 })
                .receive(on: RunLoop.main)
                .sink { error in
                    print("\(Date()) Log: ", error.message)
                }
                .store(in: &viewModel.stores)

            viewModel.isInputValid
                .receive(on: RunLoop.main)
                .map { $0 == nil }
                .assign(to: \.isEnabled, on: signInButton)
                .store(in: &viewModel.stores)

            viewModel.$isLoading
                .map({ !$0 })
                .assign(to: \.isHidden, on: indicatorView)
                .store(in: &viewModel.stores)
        }

        bindingToView()
        bindViewModelToView()
    }
    
    private func handleSignIn() {
        viewModel.signIn {
            AppDelegate.shared.setRoot(type: .tabbar)
        }
    }

    private func handleRegister() {
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }

    @IBAction private func loginTouchUpInSide(_ sender: UIButton) {


    }

    @IBAction private func signUpTouchUpInSide(_ sender: UIButton) {
        handleRegister()
    }

    @IBAction private func gotoGoogleTouchUpInSide(_ sender: UIButton) {

    }

    @IBAction private func gotoAppleTouchUpInSide(_ sender: UIButton) {

    }
}

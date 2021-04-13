//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class SignInViewController: UIViewController {

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var signInButton: UIButton!

    private var bindings = Set<AnyCancellable>()
    var viewModel: SignInViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func tapGestureRecoginer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        viewModel.signIn {
            self.indicatorView.stopAnimating()
        }
    }
}


// MARK: - private funcs
private extension SignInViewController {
    func setupBindings() {
        bindViewToViewModel()
        bindViewModelToView()
    }

    func bindViewToViewModel() {
        guard let viewModel = viewModel else { return }
        userNameTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.username, on: viewModel)
            .store(in: &bindings)
        passwordTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &bindings)
    }

    func bindViewModelToView() {
        guard let viewModel = viewModel else { return }
        viewModel.validationInput
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak self](isOkay, error) in
                guard let this = self else { return }
                if let error = error {
                    print("😵\(error.message)")
                    this.signInButton.isEnabled = false
                } else {
                    this.signInButton.isEnabled = isOkay
                }
            })
            .store(in: &bindings)

        viewModel.validationResult
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak self] (isOkay, error) in
                guard let this = self else { return }
                if let error = error {
                    print("😵\(error.message)")
                } else {
                    if isOkay {
                        this.handleSignIn()
                    }
                }
            })
            .store(in: &bindings)
    }

    func setupUI() {
        signInButton.isEnabled = false
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let viewModel = viewModel else { return }
        viewModel.checkValidate()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let viewModel = viewModel else { return false }
        viewModel.checkValidate()
        return true
    }
}

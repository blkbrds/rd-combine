//
//  RegisterViewController.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/19/21.
//

import UIKit
import Combine

final class RegisterViewController: ViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var registerScreenButton: UIButton!
    @IBOutlet private weak var loginScreenButton: UIButton!

    var viewModel = RegisterViewModel(screenType: .login)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearText()
    }

    private func configScreen(screenType: RegisterViewModel.ScreenType) {
        viewModel.isInfoValid?
            .sink { [weak self] valid in
                self?.registerButton.setTitleColor(valid ? .tintColor : .gray, for: .normal)
            }
            .store(in: &subscriptions)

        if screenType == .login {
            title = "Login"
            registerButton.setTitle("Login", for: .normal)
            registerScreenButton.isHidden = false
        } else {
            title = "Register"
            registerButton.setTitle("Register", for: .normal)
            registerScreenButton.isHidden = true
            loginScreenButton.layer.cornerRadius = loginScreenButton.frame.size.height / 2
        }
    }

    private func clearText() {
        usernameTextField.text = ""
        pwTextField.text = ""
    }

    override func configUI() {
        super.configUI()
        viewModel.state
            .map({ state -> RegisterViewModel.ScreenType? in
                if case .initial(let screenType) = state {
                    return screenType
                }
                return nil
            })
            .compactMap({ $0 })
            .sink(receiveValue: { [weak self] screenType in
                guard let self = self else { return }
                self.configScreen(screenType: screenType)
            })
            .store(in: &subscriptions)
    }

    override func bindingToView() {
        super.bindingToView()
        let loginScreenPublisher = viewModel.state
            .map { state -> RegisterViewModel.ScreenType? in
                if case .initial(let screenType) = state {
                    return screenType
                }
                return nil
            }
            .compactMap { $0 }
            .map { $0 == .register }
            .share()

        loginScreenPublisher
            .assign(to: \.isHidden, on: registerScreenButton)
            .store(in: &subscriptions)

        let registerScreenPublisher = viewModel.state
            .map({ state -> RegisterViewModel.ScreenType? in
                if case .initial(let screenType) = state {
                    return screenType
                }
                return nil
            })
            .compactMap({ $0 })
            .map({ $0 == .login })
            .share()

        registerScreenPublisher
            .assign(to: \.isHidden, on: loginScreenButton)
            .store(in: &subscriptions)

        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loginSuccess:
                    let vc: HomeViewController = HomeViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .validateFailed(let error):
                    _ = self.alert(title: "Validate Failed", message: error.message)
                case .registerSuccess:
                    let alertPublisher = self.alert(title: "", message: "Register success")
                    alertPublisher.sink { _ in
                        self.clearText()
                        self.viewModel.state.send(.initial(.login))
                    }
                    .store(in: &self.subscriptions)
                default: break
                }
            }
            .store(in: &subscriptions)
    }

    override func bindingToViewModel() {
        super.bindingToViewModel()
        usernameTextField.publisher(for: .editingChanged)
            .receive(on: DispatchQueue.main)
            .compactMap({ $0.text })
            .assign(to: \.username, on: viewModel)
            .store(in: &subscriptions)

        pwTextField.publisher(for: .editingChanged)
            .receive(on: DispatchQueue.main)
            .compactMap({ $0.text })
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
    }

    override func bindingAction() {
        super.bindingAction()
        registerButton.publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                self.viewModel.action.send(.validate)
            })
            .store(in: &subscriptions)

        registerScreenButton.publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                self.viewModel.state.send(.initial(.register))
            })
            .store(in: &subscriptions)

        loginScreenButton.publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                self.viewModel.state.send(.initial(.login))
            })
            .store(in: &subscriptions)
    }
}

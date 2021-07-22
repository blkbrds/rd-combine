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

    var viewModel = RegisterViewModel(screenType: .login)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func configScreen(screenType: RegisterViewModel.ScreenType) {
        if screenType == .login {
            title = "Login"
            registerButton.setTitle("Login", for: .normal)
            registerScreenButton.isHidden = false
        } else {
            title = "Register"
            registerButton.setTitle("Register", for: .normal)
            registerScreenButton.isHidden = true
        }
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
            .flatMap({ button -> Just<Void> in
                return Just(())
            })
            .sink(receiveValue: {
                self.viewModel.action.send(.validate)
            })
            .store(in: &subscriptions)

        registerScreenButton.publisher(for: .touchUpInside)
            .flatMap { button -> Just<Void> in
                return Just(())
            }
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.viewModel.state.send(.initial(.register))
            })
            .store(in: &subscriptions)
    }
}

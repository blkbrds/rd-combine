//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine
import SwiftUI

class SignInViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var pwTextField: UITextField!
    
    var viewModel = SignInViewModel()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()

        bindingToView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }


    private func bindingToView() {
        // username
        viewModel.$userName
            .assign(to: \.text, on: userNameTextField)
            .store(in: &subscriptions)

        // password
        viewModel.$passWord
            .assign(to: \.text, on: pwTextField)
            .store(in: &subscriptions)

        // indicator
        viewModel.$isLoading
            .sink(receiveValue: { isLoading in
                if isLoading {
                    self.indicatorView.startAnimating()
                } else {
                    self.indicatorView.stopAnimating()
                }
            })
            .store(in: &subscriptions)

        viewModel.isInputValid
    }

    private func bindingToViewModel() {
        // usernameTextField
        userNameTextField.publisher
            .assign(to: \.userName, on: viewModel)
            .store(in: &subscriptions)

        // passwordTextField
        pwTextField.publisher
            .assign(to: \.passWord, on: viewModel)
            .store(in: &subscriptions)
    }


    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {

//        indicatorView.startAnimating()
//        indicatorView.isHidden = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.indicatorView.stopAnimating()
//            self.handleSignIn()
//        }
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UITextField {
  var publisher: AnyPublisher<String?, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextField? }
      .map { $0?.text }
      .eraseToAnyPublisher()
  }
}

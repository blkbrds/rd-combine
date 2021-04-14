//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: SignInViewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        configPublishers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func configPublishers() {
        bindingData()
        handleErrors()
        
        signInButton.tapPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let this = self, this.indicatorView.isHidden else { return }
                this.indicatorView.startAnimating()
                this.indicatorView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    this.indicatorView.stopAnimating()
                    this.handleSignIn()
                }
            })
            .store(in: &subscriptions)
    }
    
    private func bindingData() {
        usernameTextField.textPublisher
            .assign(to: \.username.value, on: viewModel)
            .store(in: &subscriptions)
        
        passwordTextField.textPublisher
            .assign(to: \.password.value, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.validNamePublisher
            .combineLatest(viewModel.validPasswordPublisher)
            .map({ $0.0 == .suscess && $0.1 == .suscess })
            .assign(to: \.isEnabled, on: signInButton)
            .store(in: &subscriptions)
    }
    
    private func handleErrors() {
        viewModel.validNamePublisher
            .merge(with: viewModel.validPasswordPublisher)
            .sink { (completion) in
            if case .failure(let error) = completion {
                print(error.message)
            }
        }
        .store(in: &subscriptions)
    }
    
    private func handleSignIn() {
        if viewModel.isValidUser {
            let vc = HomeViewController()
            vc.viewModel = HomeViewModel()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Đăng nhập không thành công")
        }
    }
}

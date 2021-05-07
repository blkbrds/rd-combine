//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {

    enum Field: Int {
        case username = 0, password
    }

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!

    private var subscriptions: Set<AnyCancellable> = []
    var viewModel: SignInViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        bindViewModelToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func bindViewModelToView() {
        guard let viewModel: SignInViewModel = viewModel else { return }
        viewModel.isValid
            .assign(to: \.isEnabled, on: signInButton)
            .store(in: &subscriptions)
        viewModel.isValidUsername
            .dropFirst()
            .sink { result in
                switch result {
                case .success:
                    print("valid username")
                case .failure(let error):
                    print("username", error.message)
                }
            }
            .store(in: &subscriptions)
        viewModel.isValidPassword
            .dropFirst()
            .sink { result in
                switch result {
                case .success:
                    print("valid password")
                case .failure(let error):
                    print("password", error.message)
                }
            }
            .store(in: &subscriptions)
        viewModel.signInDone
            .sink { [weak self] done in
                guard let this = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    this.indicatorView.stopAnimating()
                    if done {
                        let vc: HomeViewController = HomeViewController()
                        vc.viewModel = HomeViewModel()
                        this.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        print("Wrong username or password")
                    }
                }
            }
            .store(in: &subscriptions)
    }

    @IBAction private func textFieldEditingChanged(_ sender: UITextField!) {
        guard let field: Field = Field(rawValue: sender.tag),
              let viewModel: SignInViewModel = viewModel else { return }
        let value: String = sender.text.orEmpty
        switch field {
        case .username:
            viewModel.username = value
        case .password:
            viewModel.password = value
        }
    }

    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        viewModel?.signInAction.send()
    }
}

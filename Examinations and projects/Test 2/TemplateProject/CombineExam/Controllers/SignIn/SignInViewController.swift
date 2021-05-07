//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!

    // MARK: - Properties
    var viewModel:SignInViewModel = SignInViewModel()
    var subscriptions = Set<AnyCancellable>()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        setupPublisher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupPublisher() {
        [userNameTextField, passWordTextField].forEach { ($0?.addTarget(self,action: #selector(inputTextField(textField:)), for: .editingChanged))
        }
        viewModel.validLogin
            .sink { value in

                if let userNameError = value.0 {
                    print(userNameError.message)
                    return
                }
                if let passwordError = value.1 {
                    print(passwordError.message)
                    return
                }
            }
            .store(in: &subscriptions)

        viewModel.checkData
            .sink { data in
                guard data else {
                    print("Tai khoan khong co")
                    return
                }
                print("dang nhap thanh cong")
                self.indicatorView.startAnimating()
                self.indicatorView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.indicatorView.stopAnimating()
                    self.handleSignIn()
                }
            }
            .store(in: &subscriptions)
    }

    @objc func inputTextField(textField: UITextField) {
        switch textField {
        case userNameTextField:
            viewModel.userName.send(textField.value)
        default:
            viewModel.passWord.send(textField.value)
        }
    }

    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        handleSignIn()
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UITextField {
    var value: String {
        guard let string = self.text else { return "" }
        return string
    }
}

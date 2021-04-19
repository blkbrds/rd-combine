//
//  SignInViewController.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var lblUsernameMessage: UILabel!
    @IBOutlet weak var lblPasswordMessage: UILabel!
    
    var viewModel: SignInViewModel?
    var usernameSubsciber: AnyCancellable?
    var passwordSubsciber: AnyCancellable?
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        self.initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }


    @IBAction private func signInButtonTouchUpInside(_ sender: UIButton) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorView.stopAnimating()
            self.handleSignIn()
        }
    }
    
    private func handleSignIn() {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignInViewController {
    fileprivate func initialization() {
        
        
        let username = viewModel?.usernameMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (str) in
                
                guard let `self` = self else {
                    return
                }
                
                self.lblUsernameMessage.text = str
        }
        usernameSubsciber = AnyCancellable(username!)
        
        let password = viewModel?.passwordMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (str) in
                
                guard let `self` = self else {
                    return
                }
                
                self.lblPasswordMessage.text = str
        }
        passwordSubsciber = AnyCancellable(password!)
        
        viewModel?.readyToSubmit
            .map { $0 != nil}
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (isEnable) in
                if isEnable {
                    self.btnLogin.backgroundColor = .systemGreen
                } else {
                    self.btnLogin.backgroundColor = .red
                }
                self.btnLogin.isEnabled = isEnable
            })
            .store(in: &cancellableSet)
    }
}

extension SignInViewController {
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        print("thu dang nhap")
    }
}

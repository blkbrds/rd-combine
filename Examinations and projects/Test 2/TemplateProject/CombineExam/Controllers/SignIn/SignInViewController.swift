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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    var viewModel: SignInViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        setupBindings()
    }
    
    private func setupBindings() {
        func bindViewToViewModel() {
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
                    
                    let isExist = self.viewModel.users.contains { $0.name == name && $0.password == pw }
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
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func handleSignIn() {
        viewModel.signIn {
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.changeRoot()
            }
        }
    }
}

//
//  SignInViewController.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/13/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

class SignInViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userNameTextFeild: UITextField!
    @IBOutlet weak var passWordTextFeild: UITextField!

    var viewModel: SignInViewModel?
    var isEnable: Bool = false
    var isCorrect: Bool = false
    var publisher = PassthroughSubject<Bool,Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3564865291, green: 0.7821497917, blue: 0.9799445271, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func userNameEditingChanged(_ sender: Any) {
        guard let userName = userNameTextFeild.text?.count else { return }
        if userName > 2 && userName < 20 {
            isEnable = true
        } else {
            print(SignInError.invalidUsernameLength.message)
        }
    }

    @IBAction func passWordEditingChanged(_ sender: Any) {
        guard let passWord = passWordTextFeild.text?.count else { return }
        if passWord > 8 && passWord < 20 {
            isEnable = true
        } else {
            print(SignInError.invalidPasswordLength.message)
        }
    }

    @IBAction func signInTouchUpInside(_ sender: Any) {
        guard let userName = userNameTextFeild.text, let passWord = passWordTextFeild.text else { return }
        for index in 0..<LocalDatabase.users.count {
            if userName == LocalDatabase.users[index].name && passWord == LocalDatabase.users[index].password {
                let vc = HomeViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                isCorrect = false
            }
        }
        if !isCorrect {
            print("Dang nhap khong thanh cong")
        }
    }
}

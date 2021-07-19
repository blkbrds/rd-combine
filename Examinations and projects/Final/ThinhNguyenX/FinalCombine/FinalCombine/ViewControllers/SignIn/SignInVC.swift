//
//  SignInVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import UIKit

class SignInVC: UIViewController {

    var viewModel: SignInViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction private func loginTouchUpInSide(_ sender: UIButton) {

        AppDelegate.shared.setRoot(type: .home)
    }

    @IBAction private func signUpTouchUpInSide(_ sender: UIButton) {

    }

    @IBAction private func gotoGoogleTouchUpInSide(_ sender: UIButton) {

    }

    @IBAction private func gotoAppleTouchUpInSide(_ sender: UIButton) {

    }
}

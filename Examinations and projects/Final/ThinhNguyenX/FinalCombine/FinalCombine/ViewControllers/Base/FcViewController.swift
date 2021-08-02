//
//  FcViewController.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 8/2/21.
//

import UIKit

class FcViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setupUI() {
        hideKeyboardWhenTappedAround()
    }

    func setupData() {

    }

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

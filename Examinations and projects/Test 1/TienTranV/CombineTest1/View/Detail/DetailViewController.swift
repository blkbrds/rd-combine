//
//  DetailViewController.swift
//  CombineTest1
//
//  Created by Tran Van Tien on R 3/02/28.
//

import UIKit

// 2. closure
typealias closure = (_ user: HomeViewController.User) -> Void

// 1. delegate
protocol DetailViewControllerDelegate: class {
    func viewController(_ viewController: DetailViewController, needsPerform action: DetailViewController.Action)
}

final class DetailViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    var user: HomeViewController.User?
    var type: HomeViewController.EditType = .delegate
    // 2. closure
    var closure: closure?
    // 1. delegate
    weak var delegate: DetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else { return }
        nameTextField.text = user.name
        addressTextField.text = user.address
    }

    @IBAction private func doneTouchUpInside(_ sender: Any) {
        let name: String = nameTextField.text ?? ""
        let address: String = addressTextField.text ?? ""
        let user = HomeViewController.User(name: name, address: address)
        switch type {
            // 1. delegate
        case .delegate:
            delegate?.viewController(self, needsPerform: .doneDelegate(user: user))
        case .closure:
            // 2. closure
            closure?(user)
        case .notification:
            // 3. notification
            NotificationCenter.default.post(name: .kNotification, object: user)
        case .combine:
            // 4. combine
            HomeViewController.editUser.send(user)
//            HomeViewController.editUser.send(completion: .finished)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didmissView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController {
    enum Action {
        case doneDelegate(user: HomeViewController.User)
    }
}

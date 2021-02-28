//
//  EditViewController.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import UIKit

// 1. Delegate
protocol EditViewControllerDelegate: class {
    func vc(_ vc: EditViewController, needsPerform action: EditViewController.Action)
}

final class EditViewController: UIViewController {

    enum Action {
        case didSelectedBackButton(user: User)
    }

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    private(set) var user: User?
    var viewModel: EditViewModel?
    // 1. Delegate
    weak var delegate: EditViewControllerDelegate?
    // 2. Closure
    var closure: ((_ user: User) -> Void)?

    override func viewDidLoad() {
        doneButton.layer.cornerRadius = 25
    }

    @IBAction private func doneButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel,
              let indexPath = viewModel.indexPath else { return }
        let _name: String = nameTextField.text ?? ""
        let _address: String = addressTextField.text ?? ""
        var user = User()
        user.name = _name
        user.address = _address
        self.user = user
        dismiss(animated: true) {
            if let title = PassDataType(rawValue: indexPath.row)?.title {
                switch title {
                // Delegate
                case "Delegate":
                    self.delegate?.vc(self, needsPerform: .didSelectedBackButton(user: user))
                // Closure
                case "Closure":
                    self.closure?(user)
                // Notification
                case "Notification":
                    let userInfo: [String: String] = ["name": _name, "address": _address]
                    NotificationCenter.default.post(name: Notification.Name.init("NotificationCenter"), object: nil, userInfo: userInfo)
                case "Combine":
                    break
                default:
                    break
                }
            }
        }
    }
}

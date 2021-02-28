//
//  EditViewController.swift
//  QueDinhT
//
//  Created by MBA0023 on 2/28/21.
//

import UIKit

enum EditType: Int {
    case delegate = 0
    case closure
    case notification
    case combine
}

// Delegate
protocol EditViewControllerDelegate: class {
    func view(_ view: EditViewController, needPerformAction action: EditViewController.Action)
}

final class EditViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    var viewModel = EditViewModel(editType: .delegate, user: User())
    weak var delegate: EditViewControllerDelegate?
    var closure: ((User) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }

    private func updateView() {
        nameTextField.text = viewModel.user.name
        addressTextField.text = viewModel.user.address
    }

    @IBAction func doneEditButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            guard let this = self else { return }
            this.viewModel.user = User(name: this.nameTextField.text ?? "",
                                  address: this.addressTextField.text ?? "")
            switch this.viewModel.editType {
            case .delegate:
                this.delegate?.view(this, needPerformAction: .updateUser(user: this.viewModel.user))
            case .closure:
                if let closure = this.closure {
                    closure(this.viewModel.user)
                }
            case .notification:
                let userInfo: [String: User] = ["user": this.viewModel.user]
                NotificationCenter.default.post(name: Notification.Name("Notification center"), object: nil, userInfo: userInfo)
            default:
                HomeViewController.userInput.send(this.viewModel.user)
            }
        }
    }

    @IBAction func dissmissButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension EditViewController {

    enum Action {
        case updateUser(user: User)
    }
}

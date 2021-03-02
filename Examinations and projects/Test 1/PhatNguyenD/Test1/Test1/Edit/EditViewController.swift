//
//  EditViewController.swift
//  Test1
//
//  Created by MBA0225 on 3/1/21.
//

import UIKit
import Combine

protocol EditViewControllerDelegate: class {
    func updateUser(_ controller: EditViewController, data: (String, String, Int))
}

final class EditViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    var viewModel = EditViewModel()
    // 1. Delegate
    weak var delegate: EditViewControllerDelegate?

    // 2. Closure
    var phat: ((EditViewModel) -> Void)?

    // 4. Combine
    var publisher: PassthroughSubject<(String, String, Int), Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = viewModel.name
        addressTextField.text = viewModel.address
    }
    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        guard let name = nameTextField.text, let address = addressTextField.text else { return }
        viewModel.name = name
        viewModel.address = address

        switch viewModel.tagEdit {
        case 0:
            delegate?.updateUser(self, data: (name, address, viewModel.tagEdit))
        case 1:
            phat?(viewModel)
        case 2:
            NotificationCenter.default.post(name: .updateUser, object: viewModel)
        default:
            publisher?.send((viewModel.name, viewModel.address, viewModel.tagEdit))
            publisher?.send(completion: .finished)
        }
        dismiss(animated: true)
    }
}

extension Notification.Name {
    static let updateUser = Notification.Name("updateUser")
}

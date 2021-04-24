//
//  EditViewController.swift
//  BaiTapCombine
//
//  Created by Trin Nguyen X on 2/28/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

// MARK: - Delegate
protocol EditViewControllerDelegate: class {
    func updateInfoUser(_ view: EditViewController, needsPerform action: EditViewController.Action)
}

final class EditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    // MARK: - Properties
    var viewModel = EditViewModel()

    // 1. Delegate
    weak var delegate: EditViewControllerDelegate?

    // 2. Closure
    var foo: ((EditViewModel) -> Void)?

    // 4. Combine
    var publisher = PassthroughSubject<EditViewModel, Never>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = viewModel.name
        addressTextField.text = viewModel.address
    }

    // MARK: - IBActions
    @IBAction private func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func doneButtonTouchUpInside(_ sender: Any) {
        guard let name = nameTextField.text, let address = addressTextField.text else { return }
        viewModel.name = name
        viewModel.address = address
        switch viewModel.tagNumber {
        case 0:
            // 1. Delegate
            delegate?.updateInfoUser(self, needsPerform: .send(name, address, viewModel.tagNumber))
        case 1:
            // 2. Closure
            foo?(viewModel)
        case 2:
            // 3. Notification
            NotificationCenter.default.post(name: .updateInfoUser, object: viewModel)
        default:
            // 4.Combine
            publisher.send((viewModel))
            publisher.send(completion: .finished)
        }
        dismiss(animated: true)
    }
}

// MARK: - Extension
extension EditViewController {
    enum Action {
        case send(String, String, Int)
    }
}

extension Notification.Name {
    static let updateInfoUser = Notification.Name("updateInfoUser")
}

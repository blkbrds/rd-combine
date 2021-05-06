//
//  EditInforViewController.swift
//  CombineTest1
//
//  Created by TanHuynh on 2021/02/28.
//

import UIKit
import Combine

class EditInforViewController: UIViewController {

    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var addressTextField: UITextField!

    var viewModel: EditInforViewModel?

    // Delegate
    weak var delegate: HomeViewControllerDelegate?

    // Closure
    var updateInfor: ((EditInforViewModel) -> Void)?

    // Publisher
    var publisher: PassthroughSubject<EditInforViewModel, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        viewModel?.name = textField.text ?? ""
    }

    @objc func addressTextFieldDidChange(_ textField: UITextField) {
        viewModel?.address = textField.text ?? ""
    }

    @IBAction private func doneButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel,
              !viewModel.name.isEmpty,
              !viewModel.address.isEmpty else {
            return
        }

        switch viewModel.type {
        case .delegate:
            delegate?.controller(controller: self, needPerform: .updateInfor(viewModel: viewModel))
        case .closure:
            updateInfor?(viewModel)
        case .notification:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateInfor), object: viewModel)
        case .combine:
            publisher?.send(viewModel)
            publisher?.send(completion: .finished)
        }

        dismiss(animated: true)
    }
}

//
//  EditViewController.swift
//  CombineTest1
//
//  Created by Thanh Nguyen X. on 02/26/21.
//

import UIKit
import Combine

// 3. Notification
extension Notification.Name {
    static let notification = Notification.Name(rawValue: "NOTIFICATION")
}

// 1. Delegate
protocol EditViewControllerDelegate: class {
    func view(_ view: EditViewController, needPerform action: EditViewController.Action)
}

final class EditViewController: UIViewController {

    enum Action {
        case updateData(Human)
    }

    @IBOutlet weak var nameEditTextField: UITextField!
    @IBOutlet weak var addressEditTextField: UITextField!

    var viewModel: EditViewModel = EditViewModel()
    weak var delegate: EditViewControllerDelegate?
    // 2. Closure
    var closure: ((Human) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }

    private func configData() {
        nameEditTextField.delegate = self
        addressEditTextField.delegate = self
        nameEditTextField.text = viewModel.human.name
        addressEditTextField.text = viewModel.human.address
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            switch self.viewModel.editType {
            case .delegate:
                self.viewModel.updateData = Human(name: self.nameEditTextField.text ?? "",
                                                  address: self.addressEditTextField.text ?? "")
                self.delegate?.view(self, needPerform: .updateData(self.viewModel.updateData ?? Human(name: "", address: "")))
            case .closure:
                if let closure = self.closure {
                    closure(Human(name: self.nameEditTextField.text ?? "",
                                  address: self.addressEditTextField.text ?? ""))
                }
            case .notification:
                let userInfo: [String: Human] = ["human": Human(name: self.nameEditTextField.text ?? "",
                                                                address: self.addressEditTextField.text ?? "")]
                NotificationCenter.default.post(name: Notification.Name.notification, object: nil, userInfo: userInfo)
            case .combine:
                let human = Human(name: self.nameEditTextField.text ?? "",
                                  address: self.addressEditTextField.text ?? "")
                AppDelegate.shared.humanCombine.send(human)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

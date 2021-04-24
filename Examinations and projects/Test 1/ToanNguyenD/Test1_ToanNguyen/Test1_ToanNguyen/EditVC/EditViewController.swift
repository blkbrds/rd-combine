//
//  EditViewController.swift
//  Test1_ToanNguyen
//
//  Created by Toan Nguyen D. [4] on 2/26/21.
//

import UIKit
import Combine

// 1. Delegate
protocol EditViewControllerDelegate: class {
    func vc(_ vc: EditViewController, needPerform action: EditViewController.Action)
}

final class EditViewController: UIViewController {

    enum Action {
        case returnData(user: UserInformation)
    }

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!

    var viewModel: EditViewModel = EditViewModel()
    var passDataClosure: ((_ user: UserInformation) -> Void)?
    var passDataCombine = PassthroughSubject<UserInformation, Never>()
    weak var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        doneButton.titleLabel?.textAlignment = .center
        doneButton.layer.cornerRadius = 10
        doneButton.layer.masksToBounds = true
        updateData()
    }

    private func updateData() {
        nameTextField.text = viewModel.user.name
        addressTextField.text = viewModel.user.address
    }

    @IBAction private func closeButtonTouchUpInside(_ button: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func doneButtonTouchUpInside(_ button: UIButton) {
        dismiss(animated: true) { [weak self] in
            guard let this = self else { return }
            switch this.viewModel.passDataType {
            // 1. Delegate
            case .delegate:
                this.delegate?.vc(this, needPerform: .returnData(user: UserInformation(name: this.nameTextField.text ?? "", address: this.addressTextField.text ?? "")))
            // 2. Closure
            case .closure:
                if let passDataClosure = this.passDataClosure {
                    passDataClosure(UserInformation(name: this.nameTextField.text ?? "", address: this.addressTextField.text ?? ""))
                }
            // 3. Notification
            case .notification:
                let userInfor: [String: UserInformation] = ["passDataInfor": UserInformation(
                                                                name: this.nameTextField.text ?? "",
                                                                address: this.addressTextField.text ?? "")]
                NotificationCenter.default.post(name: .passDataInfor, object: nil, userInfo: userInfor)
            // 4. Combine
            case .combine:
                this.passDataCombine.send(UserInformation(
                                        name: this.nameTextField.text ?? "",
                                        address: this.addressTextField.text ?? ""))
            }
        }
    }
}

//
//  EditVCDelegateWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate: class {
    func viewController(_ viewController: EditViewController, needPerforms action: EditVCDelegateWay.Action)
}

final class EditVCDelegateWay: EditViewController {

    enum Action {
        case didEdit(newUser: User)
    }
    
    override var nibName: String? {
        return "EditViewController"
    }

    weak var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel as? EditViewModelNormalWay else { return }
        configUIWithUser(user: viewModel.user)
    }

    override func doneButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel as? EditViewModelNormalWay else { return }
        let newUser = viewModel.user
        newUser.name = editNameTextField.text ?? ""
        newUser.address = editAddressTextField.text ?? ""
        delegate?.viewController(self, needPerforms: .didEdit(newUser: newUser))
        dismiss(animated: true, completion: nil)
    }
}

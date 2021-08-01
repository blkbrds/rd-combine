//
//  EditVCClosureWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

final class EditVCClosureWay: EditViewController {
    
    override var nibName: String? {
        return "EditViewController"
    }

    var didEdit: ((User) -> ())?

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
        didEdit?(newUser)
        dismiss(animated: true, completion: nil)
    }
}

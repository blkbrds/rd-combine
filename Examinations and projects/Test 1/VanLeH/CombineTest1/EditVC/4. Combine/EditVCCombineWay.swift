//
//  EditVCCombineWay.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

final class EditVCCombineWay: EditViewController {

    private var subscriptions = Set<AnyCancellable>()

    override var nibName: String? {
        return "EditViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel as? EditViewModelCombineWay else { return }
        viewModel.userSubject
            .sink { [weak self] user in
                self?.configUIWithUser(user: user)
            }
            .store(in: &subscriptions)
    }

    override func doneButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel as? EditViewModelCombineWay else { return }
        let newUser = viewModel.userSubject.value
        newUser.name = editNameTextField.text ?? ""
        newUser.address = editAddressTextField.text ?? ""
        viewModel.userSubject.send(newUser)
        dismiss(animated: true, completion: nil)
    }
}

//
//  EditViewController.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/27/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editAddressTextField: UITextField!

    var viewModel: EditViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tag = viewModel.tag
    }

    func configUIWithUser(user: User) {
        editNameTextField.text = user.name
        editAddressTextField.text = user.address
    }

    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonTouchUpInside(_ sender: Any) { }
}

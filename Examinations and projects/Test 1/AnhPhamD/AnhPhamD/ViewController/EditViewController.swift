//
//  ViewController.swift
//  AnhPhamD
//
//  Created by AnhPhamD. [2] on 2/25/21.
//  Copyright © 2021 AnhPhamD. [2]. All rights reserved.
//

import UIKit
import Combine

protocol EditViewControllerDelegate: class {
    func sendInfo(_ view: EditViewController, needsPerform action: EditViewController.Action)
}

class EditViewController: UIViewController {

    enum Action {
        case send(String, String, Int)
    }

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    weak var delegate: EditViewControllerDelegate?
    
    // Delegate
    var viewModel: EditViewModel?
    
    // Closure
    var foo: ((EditViewModel) -> Void)?

    // Combine
    var passthroughSubject = PassthroughSubject<EditViewModel, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        nameTextField.text = viewModel.name
        addressTextField.text = viewModel.address
        // Do any additional setup after loading the view.
    }

    
    @IBAction private func confirmButtonTouchUpInSide(_ sender: UIButton) {
        guard let viewModel = viewModel, let name = nameTextField.text, let address = addressTextField.text else { return }
        viewModel.name = name
        viewModel.address = address
        switch viewModel.tagNumber {
        case 0:
            // Delegate
            delegate?.sendInfo(self, needsPerform: .send(name, address, viewModel.tagNumber))
        case 1:
            // Closure
            foo?(viewModel)
        case 2:
            // Notification
            NotificationCenter.default.post(name: .updateInformation, object: viewModel)
        case 3:
            // Combine
            passthroughSubject.send(viewModel)
            passthroughSubject.send(completion: .finished)
        default: break
        }
        dismiss(animated: true)
    }
}

extension Notification.Name {
    static let updateInformation = Notification.Name(rawValue: "updateInformation")
}



//
//  EditViewController.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/2/21.
//

import UIKit

protocol EditViewControllerDelegate: class {
    func viewController(_ viewController: EditViewController, needPerforms action: EditViewController.Action)
}

enum TypeOfUse {
    case editDelegate
    case editClosure
    case editNotification
    case editCombine
}

final class EditViewController: UIViewController {

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    enum Action {
        case updateUser(_ newUser: User)
    }
    
    weak var delegate: EditViewControllerDelegate?
    var typeOfUse: TypeOfUse = .editDelegate
    var viewModel: EditViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        editButton.layer.cornerRadius = 8
        nameTextField.layer.cornerRadius = 8
        addressTextField.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 1.0
        addressTextField.layer.borderWidth = 1.0
    }
    
    
    @IBAction func closeTouchUpInside(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTouchUpInside(_ sender: Any) {
        switch typeOfUse {
        case .editDelegate:
            delegate?.viewController(self, needPerforms: .updateUser(User(name: nameTextField.text ?? "", address: addressTextField.text ?? "")))
            dismiss(animated: true, completion: nil)
        case .editClosure:
            if let viewModel = viewModel {
                viewModel.user?.name = nameTextField.text ?? ""
                viewModel.user?.address = addressTextField.text ?? ""
            }
            dismiss(animated: true, completion: nil)
        case .editNotification: break
        case .editCombine: break
        }
    }
}

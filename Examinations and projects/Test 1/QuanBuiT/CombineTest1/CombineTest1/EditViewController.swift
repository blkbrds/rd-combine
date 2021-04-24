//
//  EditViewController.swift
//  CombineTest1
//
//  Created by MBA0253P on 2/28/21.
//

import UIKit
import Combine

// 1. Delegate
protocol EditViewControllerDelegate: class {
    func updateDataUser(_ controller: EditViewController, data: (String, String, Int))
}

final class EditViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    
    var viewModel = EditViewModel()
    
    // 1. Delegate
    weak var delegate: EditViewControllerDelegate?
    
    // 2. Closure
    var foo: ((EditViewModel) -> Void)?
    
    // 4. Combine
    var publisher: PassthroughSubject<(String, String, Int), Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = viewModel.name
        addressTextField.text = viewModel.address
    }
    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        guard let name = nameTextField.text, let address = addressTextField.text else { return }
        viewModel.name = name
        viewModel.address = address
        
        switch viewModel.tagEdit {
        case 0:
            // 1. Delegate
            delegate?.updateDataUser(self, data: (name, address, viewModel.tagEdit))
        case 1:
            // 2. Closure
            foo?(viewModel)
        case 2:
            // 3. Notification
            NotificationCenter.default.post(name: .updateDataUser, object: viewModel)
        default:
            // 4.Combine
            publisher?.send((viewModel.name, viewModel.address, viewModel.tagEdit))
            publisher?.send(completion: .finished)
        }
        
        dismiss(animated: true)
    }
}

extension Notification.Name {
    static let updateDataUser = Notification.Name("updateDataUser")
}

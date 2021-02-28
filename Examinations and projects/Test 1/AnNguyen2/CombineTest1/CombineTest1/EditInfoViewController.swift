//
//  EditInfoViewController.swift
//  CombineTest1
//
//  Created by MBA0283F on 2/26/21.
//

import UIKit
import Combine

// 1. Delegate
protocol EditInfoViewControllerDelegate: class {
    func editInfoViewController(vc: UIViewController, perform action: EditInfoViewController.Action)
}

final class EditInfoViewModel {
    var tag: Int
    var username: String
    var address: String
    
    init(tag: Int = 0, username: String = "", address: String = "") {
        self.tag = tag
        self.username = username
        self.address = address
    }
}

final class EditInfoViewController: UIViewController {
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var addressTextField: UITextField!
    
    var viewModel: EditInfoViewModel = EditInfoViewModel()
    
    // 1. Delegate
    enum Action {
        case editedInfo
        case cancel
    }
    
    weak var delegate: EditInfoViewControllerDelegate?

    // 2. Closure
    var editInfo: ((EditInfoViewModel) -> Void)?
        
    // 4. Combine
    var viewModelPublisher: PassthroughSubject<EditInfoViewModel, Never>?
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneButton(_ sender: Any) {
        guard let username = usernameTextField.text,  !username.isEmpty,
              let address = addressTextField.text, !address.isEmpty else {
            return
        }
        viewModel.username = username
        viewModel.address = address
        
        // 1. Delegate
        delegate?.editInfoViewController(vc: self, perform: .editedInfo)
        dismiss(animated: true)
        
        // 2. Closure
        editInfo?(viewModel)
        
        // 3. Notification
        NotificationCenter.default.post(name: .didReceiveInfo, object: viewModel)
        
        // 4. Combine
        viewModelPublisher?.send(viewModel)
        viewModelPublisher?.send(completion: .finished)
    }
}

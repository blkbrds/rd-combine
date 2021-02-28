//
//  EditViewController.swift
//  Exercise Combine
//
//  Created by MBA0052 on 2/25/21.
//

import UIKit
import Combine

protocol EditViewControllerDelegate: class {
    func viewController(_ view: EditViewController, needsPerform action: EditViewController.Action)
}
class EditViewController: UIViewController {
    
    enum Action {
        case done(String, String)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: EditViewControllerDelegate?
    var viewModel: EditViewModel = EditViewModel()
    
    var editInformation:((EditViewModel) -> Void)?
    var type: EditType = .delegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        
        guard let name: String = nameTextField.text,
              let address: String = addressTextField.text,
              !name.isEmpty,
              !address.isEmpty else {
            let alert: UIAlertController = UIAlertController(title: "WARNING",
                                                             message: "Name or address is empty", preferredStyle: .alert)
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            alert.view.tintColor = .systemRed
            self.present(alert, animated: true)
            return
        }
        viewModel.name = nameTextField.text ?? ""
        viewModel.address = addressTextField.text ?? ""
        switch type {
        case .delegate:
            delegate?.viewController(self, needsPerform: .done(name, address))
        case .notification:
            let userInfo: [String : String] = ["name": name, "address": address]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: HomeViewController.getNotification), object: nil, userInfo: userInfo)
        case .closure:
            editInformation?(viewModel)
        case .combine:
            HomeViewController.userInput.send(User(name: name, address: address))
        }
        dismiss(animated: true, completion: nil)
    }
}

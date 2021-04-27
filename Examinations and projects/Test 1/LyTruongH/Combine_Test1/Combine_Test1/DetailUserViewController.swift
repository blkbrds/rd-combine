//
//  DetailUserViewController.swift
//  Combine_Test1
//
//  Created by Ly Truong H. on 2/27/21.
//

import UIKit

protocol DetailUserViewControllerDelegate: class {
    func viewController(_ view: DetailUserViewController, needsPerform action: DetailUserViewController.Action)
}

class DetailUserViewController: UIViewController {
    
    enum Action {
        case done(String, String)
    }

    @IBOutlet weak var nameEditTextField: UITextField!
    @IBOutlet weak var addressEditTextField: UITextField!
    
    var closure: ((String, String) -> Void)?
    var type: EditType = .delegate
    weak var delegate: DetailUserViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameEditTextField.delegate = self
        addressEditTextField.delegate = self
    }

    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let name: String = nameEditTextField.text ?? ""
        let address: String = addressEditTextField.text ?? ""
        switch type {
        case .delegate:
            delegate?.viewController(self, needsPerform: .done(name, address))
        case .closure:
            closure?(name, address)
        case .notification:
            let userInfo: [String : String] = ["name": name, "address": address]
            NotificationCenter.default.post(name: Notification.Name(HomeViewController.kNotification), object: nil, userInfo: userInfo)
        case .combine:
            HomeViewController.userInput.send(User(name: name, address: address))
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension DetailUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

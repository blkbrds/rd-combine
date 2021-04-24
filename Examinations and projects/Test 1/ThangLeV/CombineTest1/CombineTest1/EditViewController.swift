//
//  EditViewController.swift
//  CombineTest1
//
//  Created by MBA0183 on 2/26/21.
//

import UIKit
import Combine

extension Notification.Name {
    static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
}

protocol EditViewControllerDelegate: class {
    func passDataBackToHome(userName: String, address: String)
}

class EditViewController: BaseViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    weak var delegate: EditViewControllerDelegate?
    var completionHandler: ((String, String) -> Void)?
    let passthroughSubject: PassthroughSubject = PassthroughSubject<String, Never>()
    
    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        guard let userNameText = userNameTextField.text,
              let addressText = addressTextField.text else { return }
        delegate?.passDataBackToHome(userName: userNameText, address: addressText)
        completionHandler?(userNameText, addressText)
        passthroughSubject.send(userNameText)
        passthroughSubject.send(addressText)
        passthroughSubject.send(completion: .finished)
        let userInfo = ["userName" : userNameText, "address": addressText]
        NotificationCenter.default.post(name: .myNotificationKey,
                                        object: nil,
                                        userInfo: userInfo)
        dismiss(animated: true)
    }
}

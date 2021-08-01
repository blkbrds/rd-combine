//
//  EditViewController.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/26/21.
//

import UIKit
import Combine

// [1][Update] - Delegate - Create delegate
protocol EditViewControllerDelegate: class {
    func controller(_ controller: EditViewController, needsPerform action: Action<Person>)
}

final class EditViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!

    private let person: Person
    var pattern: Pattern?
    // [1][Update] - Delegate: Create instance
    weak var delegate: EditViewControllerDelegate?
    // [2][Update] - Closure - Declare closure
    var updateHandler: ((Person) -> Void)?
    // [4][Update] - Combine - Define publisher
    let updatePublisher: PassthroughSubject<Person, Never> = PassthroughSubject<Person, Never>()
    
    required init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == view {
            view.endEditing(true)
        }
    }
    
    private func configureUI() {
        doneButton.layer.cornerRadius = 10.0
        nameTextField.text = person.name
        addressTextField.text = person.address
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let text: String = sender.text else { return }
        switch sender {
        case nameTextField:
            person.name = text
        case addressTextField:
            person.address = text
        default:
            break
        }
    }
    
    @IBAction private func closeButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func doneButtonTouchUpInside(_ sender: UIButton) {
        guard let pattern: Pattern = pattern, person.isValid else {
            return
        }
        switch pattern {
        case .delegate:
            // [1][Update] - Delegate - Call delegate
            delegate?.controller(self, needsPerform: .update(person))
        case .closure:
            // [2][Update] - Closure - Call closure
            updateHandler?(person)
        case .notification:
            // [3][Update] - Notification - Post notification
            NotificationCenter.default.post(name: .UpdateInformation, object: person)
        case .combine:
            // [4][Update] - Combine - Emit value
            updatePublisher.send(person)
        }
        dismiss(animated: true)
    }
}

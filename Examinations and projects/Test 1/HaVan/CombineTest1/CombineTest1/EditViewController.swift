//
//  EditViewController.swift
//  CombineTest1
//
//  Created by NganHa on 28/02/2021.
//

import UIKit
import Combine

// delegate
protocol EditViewControllerDelegate: class {

    func view(_ view: EditViewController, needsPerform action: EditViewController.Action)
}

final class EditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!

    // MARK: - Propeties
    var viewModel: EditViewModel?
    weak var delegate: EditViewControllerDelegate?
    // comnbine
    var publisher: PassthroughSubject<EditViewModel, Never>?
    // MARK: - Initialize
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    // MARK: - Override functions
    
    // MARK: - Private functions
    private func setUpUI() {
        doneButton.layer.cornerRadius = 10
        doneButton.clipsToBounds = true
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.borderColor = UIColor.black.cgColor
        addressTextField.layer.borderWidth = 0.5
        addressTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.delegate = self
        addressTextField.delegate = self
        guard let viewModel = viewModel else { return }
        nameTextField.text = viewModel.name
        addressTextField.text = viewModel.address
    }
    // MARK: - Public functions
    
    // MARK: - Objc functions
    
    // MARK: - IBActions
    @IBAction private func doneButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        switch viewModel.editCase {
        case .delegate:
            delegate?.view(self, needsPerform: .updateInformation(name: viewModel.name, address: viewModel.address))
        case .notification:
        break
        case .combine:
            publisher?.send(viewModel)
            publisher?.send(completion: .finished)
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func exitButtonTouchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditViewController {

    enum Action {
        case updateInformation(name: String, address: String)
    }
}

// MARK: - UITextFieldDelegate
extension EditViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let viewModel = viewModel else { return false }
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            viewModel.updateName(name: nameTextField.text)
            addressTextField.becomeFirstResponder()
        case addressTextField:
            addressTextField.resignFirstResponder()
            viewModel.updateAddress(address: addressTextField.text)
        default:
            break
        }
        return true
    }
}

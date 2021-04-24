//
//  EditVC.swift
//  HungPhamV
//
//  Created by Hung Pham V. on 2/25/21.
//

import UIKit
import Combine

protocol EditVCDelegate: class {
    func handleEditInfo(_ controller: EditVC, needsPerform action: EditVC.Action)
}

final class EditVC: UIViewController {

    enum Action {
        case edit(name: String, address: String)
    }

    // MARK: - Properties
    let viewModel: EditVM = EditVM()
    weak var delegate: EditVCDelegate?
    var doneCompletion: ((String, String) -> Void)?

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!

    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    @IBAction func doneTouchUpInside(_ sender: Any) {
        if let name: String = nameTextField.text,
           let address: String = addressTextField.text,
           !name.isEmpty, !address.isEmpty {
            handleEvent(name: name, address: address)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Error",
                                                             message: "Check Input Value Again", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Private Function
    private func configUI() {
        configureBackBarButton()
        // Title
        self.title = "Edit Information"
        nameTextField.text = viewModel.name
        addressTextField.text = viewModel.address
    }

    private func configureBackBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self,
                                                            action: #selector(backBarButtonTouchUpInside))
    }

    @objc func backBarButtonTouchUpInside() {
        self.dismiss(animated: true, completion: nil)
    }

    private func handleEvent(name: String, address: String) {
        switch viewModel.types {
        case .delegate:
            delegate?.handleEditInfo(self, needsPerform: .edit(name: name, address: address))
        case .closure:
            doneCompletion?(name, address)
        case .notification:
            let user: UserInfo = UserInfo(name: name, address: address)
            NotificationCenter.default.post(name: .DidEditInfo, object: user)
        case .combine:
            viewModel.publisher.send(UserInfo(name: name, address: address))
        }
    }
}

struct UserInfo {
    var name: String
    var address: String
}

//
//  EditViewController.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 2/28/21.
//

import UIKit
import Combine

protocol EditViewControllerDelegate: class {
    func controller(_ controller: EditViewController, needsPerform action: EditViewController.Action)
}

final class EditViewController: ViewController {

    // 1.Delegate
    enum Action {
        case updateInfo(info: Info)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!

    // MARK: - Properties
    var viewModel: EditViewModel?

    // 1. Delegate
    weak var delegate: EditViewControllerDelegate?

    // 2. Closure
    var updateInfoCompletion: ((Info) -> Void)?

    // 4. Combine
    var subject: PassthroughSubject<Info, Never> = PassthroughSubject<Info, Never>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    // MARK: - Private func
    private func configView() {
        guard let viewModel = viewModel, let info = viewModel.info else { return }
        nameTextField.text = info.name
        addressTextField.text = info.address
    }

    // MARK: - IBActions
    @IBAction private func closeButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func doneButtonTouchUpInisde(_ sender: UIButton) {
        guard let viewModel = viewModel else {
            dismiss(animated: true, completion: nil)
            return
        }
        let name = nameTextField.text
        let address = addressTextField.text
        switch viewModel.fromViewType {
        case .delegate:
            delegate?.controller(self, needsPerform: .updateInfo(info: viewModel.createInfoObject(name: name, address: address)))
        case .closure:
            updateInfoCompletion?(viewModel.createInfoObject(name: name, address: address))
        case .notification:
            NotificationCenter.default.post(name: .updateInfo, object: viewModel.createInfoObject(name: name, address: address))
        case .combine:
            subject.send(viewModel.createInfoObject(name: name, address: address))
        }
        dismiss(animated: true, completion: nil)
    }
}

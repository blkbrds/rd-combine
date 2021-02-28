//
//  EditVC.swift
//  CombineTest1
//
//  Created by MBA0288F on 2/26/21.
//

import UIKit
import Combine

// 1. Delegate

protocol EditVCDelegate: class {
    func viewController(_viewController: EditVC, needPerforms action: EditVC.Action)
}

final class EditVC: UIViewController {
    
    enum Action {
        case done(UserInfomation)
    }
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!
    
    var viewModel: EditVM!
    
    // 1. Delegate
    weak var delegate: EditVCDelegate?
    
    // 2. Closure
    var closureUserInfo: ((UserInfomation) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = 5
        updateView()
    }
    
    private func updateView() {
        guard let vm = viewModel else { return }
        nameTextField.text = vm.userInfo.name
        addressTextField.text = vm.userInfo.address
    }

    @IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: UIButton) {
        let name: String = nameTextField.text ?? ""
        let address: String = addressTextField.text ?? ""
        let userInfo: UserInfomation = UserInfomation(name: name, address: address)
        
        switch viewModel.type {
        case .delegate:
            // 1. Delegate
            delegate?.viewController(_viewController: self, needPerforms: .done(userInfo))
        case .closure:
            // 2. Closure
            closureUserInfo?(userInfo)
        case .notification:
            // 3. Notification
            let userInfo: [String: Any] = ["name": name, "address": address]
            NotificationCenter.default.post(name: .editSuccess, object: self, userInfo: userInfo)
        case .combine:
            // 4. Combine
            viewModel.userInfoCombine.send(userInfo)
        }
        dismiss(animated: true)
    }
}

final class EditVM {
    var userInfo: UserInfomation
    var type: ViewType
    
    // 4. Combine
    var userInfoCombine: PassthroughSubject<UserInfomation, Never> = PassthroughSubject<UserInfomation, Never>()
    
    init(userInfo: UserInfomation, type: ViewType) {
        self.userInfo = userInfo
        self.type = type
    }
}

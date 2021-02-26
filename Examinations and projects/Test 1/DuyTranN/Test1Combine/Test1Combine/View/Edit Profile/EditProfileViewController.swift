//
//  EditProfileViewController.swift
//  Test1Combine
//
//  Created by Duy Tran N. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine

protocol EditProfileViewControllerDelegate: class {
    func viewController(_ controller: EditProfileViewController, didUpdate data: UserInfoViewModel)
}

final class EditProfileViewController: UIViewController {

    // MARK: - Enumeration
    enum ScreenType {
        case delegate
        case closure
        case notification
        case combine
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!

    // MARK: - Properties
    let screenType: ScreenType
    weak var delegate: EditProfileViewControllerDelegate?
    var closureHandler: ((UserInfoViewModel) -> Void)?
    var viewModel = EditProfileViewModel(userNameSubject: nil, addressSubject: nil)

    // MARK: - Life cycle
    init(screenType: ScreenType) {
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBActions
    @IBAction private func dismissButtonTouchUpInside(_ button: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func doneButtonTouchUpInside(_ button: UIButton) {
        guard let userName = userNameTextField.text else { fatalError("🧨 ko chịu nhập nè") }
        guard let address = addressTextField.text else { fatalError("🧨 ko chịu nhập nè") }

        let userInfoVM = UserInfoViewModel(userName: userName, address: address)

        switch screenType {
        case .delegate:
            /// `Delegate`
            delegate?.viewController(self, didUpdate: userInfoVM)
        case .closure:
            /// `Closure`
            closureHandler?(userInfoVM)
        case .notification:
            /// `Notification`
            let userDict: [String: String] = ["userName": userName, "address": address]
            NotificationCenter.default.post(name: .updateUserInfo, object: nil, userInfo: userDict)
        case .combine:
            /// `Combine`
            viewModel.userNameSubject?.send(userName)
            viewModel.addressSubject?.send(address)
        }

        dismiss(animated: true)
    }
}

// MARK: - EditProfileViewModel
class EditProfileViewModel {

    // MARK: Properties
    var userNameSubject: CurrentValueSubject<String, Never>?
    var addressSubject: CurrentValueSubject<String, Never>?

    // MARK: Life cycle
    init(userNameSubject: CurrentValueSubject<String, Never>?,
         addressSubject: CurrentValueSubject<String, Never>?) {
        self.userNameSubject = userNameSubject
        self.addressSubject = addressSubject
    }
}

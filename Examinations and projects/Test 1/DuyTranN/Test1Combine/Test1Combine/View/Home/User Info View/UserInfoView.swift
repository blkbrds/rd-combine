//
//  UserInfoView.swift
//  Test1Combine
//
//  Created by Duy Tran N. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine

final class UserInfoView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var updateProfileButton: UIButton!

    // MARK: - Properties
    var tapUpdateButton: (() -> Void)?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateProfileButton.titleLabel?.textAlignment = .center
    }

    // MARK: - Public functions
    func updateView(with viewModel: UserInfoViewModel) {
        userNameLabel.text = viewModel.userName
        addressLabel.text = viewModel.address
        updateProfileButton.setTitle(viewModel.buttonTitle, for: .normal)
        /// Binding area for Combine
        if viewModel.userNameSubject != nil, viewModel.addressSubject != nil {
            userNameLabel.text = viewModel.userNameSubject?.value
            addressLabel.text = viewModel.addressSubject?.value
        }
    }

    // MARK: - IBActions
    @IBAction private func updateProfileButtonTouchUpInside(_ button: UIButton) {
        tapUpdateButton?()
    }
}

// MARK: - UserInfoViewModel
class UserInfoViewModel {

    // MARK: Properties
    var userName: String = "No Data"
    var address: String = "No Data"
    var buttonTitle: String = ""
    /// Variable for combine
    var userNameSubject: CurrentValueSubject<String, Never>?
    var addressSubject: CurrentValueSubject<String, Never>?

    // MARK: Life cycle
    init(userName: String = "No Data",
         address: String = "No Data",
         buttonTitle: String = "",
         userNameSubject: CurrentValueSubject<String, Never>? = nil,
         addressSubject: CurrentValueSubject<String, Never>? = nil) {
        self.userName = userName
        self.address = address
        self.buttonTitle = buttonTitle
        self.userNameSubject = userNameSubject
        self.addressSubject = addressSubject
    }
}

//
//  HomeViewController.swift
//  Test1Combine
//
//  Created by Duy Tran N. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    // MARK: - Properties
    var viewModel = HomeViewModel()

    // MARK: - IBOutlets
    @IBOutlet private weak var delegateView: UserInfoView!
    @IBOutlet private weak var closureView: UserInfoView!
    @IBOutlet private weak var notificationView: UserInfoView!
    @IBOutlet private weak var combineView: UserInfoView!

    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// First init
        delegateView.updateView(with: viewModel.delegateInfoVM)
        closureView.updateView(with: viewModel.closureInfoVM)
        notificationView.updateView(with: viewModel.notificationInfoVM)
        combineView.updateView(with: viewModel.combineInfoVM)

        /// `Tap detect`
        /// - `Delegate view`
        delegateView.tapUpdateButton = { [weak self] in
            guard let this = self else { return }
            let vc = EditProfileViewController(screenType: .delegate)
            vc.delegate = this
            this.present(vc, animated: true)
        }

        /// - `Closure View`
        closureView.tapUpdateButton = { [weak self] in
            guard let this = self else { return }
            let vc = EditProfileViewController(screenType: .closure)
            this.present(vc, animated: true)
            /// Setup closure body
            vc.closureHandler = { [weak self] data in
                guard let this = self else { return }
                /// Update data
                this.viewModel.updateClosureVM(with: data)
                /// Update view
                this.closureView.updateView(with: this.viewModel.closureInfoVM)
            }
        }

        /// - `Notification View`
        notificationView.tapUpdateButton = { [weak self] in
            guard let this = self else { return }
            let vc = EditProfileViewController(screenType: .notification)
            this.present(vc, animated: true)
            /// Setup notification observer
            NotificationCenter.default.addObserver(this,
                                                   selector: #selector(this.receivedUpdateInfoNotification(_:)),
                                                   name: .updateUserInfo,
                                                   object: nil)
        }

        /// - `Combine View`
        combineView.tapUpdateButton = { [weak self] in
            guard let this = self else { return }
            let vc = EditProfileViewController(screenType: .combine)
            let vcVM = EditProfileViewModel(userNameSubject: this.viewModel.combineInfoVM.userNameSubject,
                                            addressSubject: this.viewModel.combineInfoVM.addressSubject)
            vc.viewModel = vcVM
            this.present(vc, animated: true)

            /// `Binding`
            this.viewModel.combineInfoVM.userNameSubject?
                .sink(receiveValue: { value in
                    this.combineView.updateView(with: this.viewModel.combineInfoVM)
                })
                .store(in: &this.subscriptions)
            this.viewModel.combineInfoVM.addressSubject?
                .sink(receiveValue: { value in
                    this.combineView.updateView(with: this.viewModel.combineInfoVM)
                })
                .store(in: &this.subscriptions)
        }
    }

    @objc private func receivedUpdateInfoNotification(_ notification: Notification) {
        /// Update data
        viewModel.updateNotificationVM(from: notification)
        /// Update view
        notificationView.updateView(with: viewModel.notificationInfoVM)
    }
}

// MARK: - Extension EditProfileViewControllerDelegate
extension HomeViewController: EditProfileViewControllerDelegate {
    func viewController(_ controller: EditProfileViewController, didUpdate data: UserInfoViewModel) {
        /// Update data
        viewModel.updateDelegateVM(with: data)
        /// Update view
        delegateView.updateView(with: viewModel.delegateInfoVM)
    }
}

// MARK: - HomeViewModel
struct HomeViewModel {

    // MARK: Properties
    private(set) var delegateInfoVM = UserInfoViewModel(buttonTitle: "Edit (Delegate)")
    private(set) var closureInfoVM = UserInfoViewModel(buttonTitle: "Edit (Closure)")
    private(set) var notificationInfoVM = UserInfoViewModel(buttonTitle: "Edit (Notification)")
    private(set) var combineInfoVM = UserInfoViewModel(buttonTitle: "Edit (Combine)",
                                          userNameSubject: CurrentValueSubject<String, Never>("No data"),
                                          addressSubject: CurrentValueSubject<String, Never>("No data"))

    // MARK: Public functions
    func updateDelegateVM(with newData: UserInfoViewModel) {
        delegateInfoVM.userName = newData.userName
        delegateInfoVM.address = newData.address
    }

    func updateClosureVM(with newData: UserInfoViewModel) {
        closureInfoVM.userName = newData.userName
        closureInfoVM.address = newData.address
    }

    func updateNotificationVM(from notification: Notification) {
        guard let userInfo = notification.userInfo,
              let userName = userInfo["userName"] as? String,
              let address = userInfo["address"] as? String else { fatalError("🧨 Tạch") }
        notificationInfoVM.userName = userName
        notificationInfoVM.address = address
    }
}

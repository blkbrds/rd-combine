//
//  HomeViewController.swift
//  Test1_ToanNguyen
//
//  Created by Toan Nguyen D. [4] on 2/26/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    // MARK: - Outlets
    // delegate outlets
    @IBOutlet private weak var nameDelegateLabel: UILabel!
    @IBOutlet private weak var addressDelegateLabel: UILabel!
    @IBOutlet private weak var editDelegateButton: UIButton!

    // closure outlets
    @IBOutlet private weak var nameClosureLabel: UILabel!
    @IBOutlet private weak var addressClosureLabel: UILabel!
    @IBOutlet private weak var editClosureButton: UIButton!

    // nofitication outlets
    @IBOutlet private weak var nameNofiticationLabel: UILabel!
    @IBOutlet private weak var addressNofiticationLabel: UILabel!
    @IBOutlet private weak var editNofiticationButton: UIButton!

    // combine outlets
    @IBOutlet private weak var nameCombineLabel: UILabel!
    @IBOutlet private weak var addressCombineLabel: UILabel!
    @IBOutlet private weak var editCombineButton: UIButton!

    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receivedNotification(_:)),
                                               name: .passDataInfor,
                                               object: nil)
    }

    private func configUI() {
        configButton(title: Config.editDelegateButtonName, button: editDelegateButton)
        configButton(title: Config.editClosureButtonName, button: editClosureButton)
        configButton(title: Config.editNotificationButtonName, button: editNofiticationButton)
        configButton(title: Config.editCombineButtonName, button: editCombineButton)
    }

    private func configButton(title: String, button: UIButton) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
    }

    @objc private func receivedNotification(_ notification: Notification) {
        if let user = notification.userInfo?["passDataInfor"] as? UserInformation {
            nameNofiticationLabel.text = user.name
            addressNofiticationLabel.text = user.address
        }
    }

    // 1. Delegate
    @IBAction private func editDelegateButtonTouchUpInside(_ button: UIButton) {
        let vc = EditViewController()
        vc.delegate = self
        vc.viewModel = EditViewModel(passDataType: .delegate,
                                     user: UserInformation(name: nameDelegateLabel.text ?? "",
                                                           address: addressDelegateLabel.text ?? ""))
        present(vc, animated: true)
    }

    // 2. Closure
    @IBAction private func editClosureButtonTouchUpInside(_ button: UIButton) {
        let vc = EditViewController()
        vc.viewModel = EditViewModel(passDataType: .closure,
                                     user: UserInformation(name: nameClosureLabel.text ?? "",
                                                           address: addressClosureLabel.text ?? ""))
        vc.passDataClosure = { [weak self] user in
            guard let this = self else { return }
            this.nameClosureLabel.text = user.name
            this.addressClosureLabel.text = user.address
        }
        present(vc, animated: true)
    }

    // 3. Notification
    @IBAction private func editNotificationButtonTouchUpInside(_ button: UIButton) {
        let vc = EditViewController()
        vc.viewModel = EditViewModel(passDataType: .notification,
                                     user: UserInformation(name: nameNofiticationLabel.text ?? "",
                                                           address: addressNofiticationLabel.text ?? ""))
        present(vc, animated: true)
    }

    // 4. Combine
    @IBAction private func editCombineButtonTouchUpInside(_ button: UIButton) {
        let vc = EditViewController()
        vc.viewModel = EditViewModel(passDataType: .combine,
                                     user: UserInformation(name: nameCombineLabel.text ?? "",
                                                           address: addressCombineLabel.text ?? ""))
        vc.passDataCombine.sink { [weak self] user in
            guard let this = self else { return }
            this.nameCombineLabel.text = user.name
            this.addressCombineLabel.text = user.address
        }.store(in: &subscriptions)
        present(vc, animated: true)
    }
}

extension HomeViewController: EditViewControllerDelegate {

    func vc(_ vc: EditViewController, needPerform action: EditViewController.Action) {
        switch action {
        case .returnData(user: let user):
            nameDelegateLabel.text = user.name
            addressDelegateLabel.text = user.address
        }
    }
}

extension HomeViewController {

    struct Config {
        static let editDelegateButtonName: String = "Edit\n(Delegate)"
        static let editClosureButtonName: String = "Edit\n(Closure)"
        static let editNotificationButtonName: String = "Edit\n(Notification)"
        static let editCombineButtonName: String = "Edit\n(Combine)"
    }
}

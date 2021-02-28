//
//  HomeViewController.swift
//  QueDinhT
//
//  Created by MBA0023 on 2/28/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    @IBOutlet private weak var nameDelegateLabel: UILabel!
    @IBOutlet private weak var nameClosureLabel: UILabel!
    @IBOutlet private weak var nameNotificationLabel: UILabel!
    @IBOutlet private weak var nameCombineLabel: UILabel!
    @IBOutlet private weak var addressDelegateLabel: UILabel!
    @IBOutlet private weak var addressClosureLabel: UILabel!
    @IBOutlet private weak var addressNotificationLabel: UILabel!
    @IBOutlet private weak var addressCombineLabel: UILabel!

    var viewModel = HomeViewModel()

    // Combine
    static let userInput = PassthroughSubject<User, Never>()
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataNotif(notification:)),
                                               name: Notification.Name("Notification center"), object: nil)
    }

    private func updateView() {
        nameDelegateLabel.text = viewModel.users[0].name
        nameClosureLabel.text = viewModel.users[1].name
        nameNotificationLabel.text = viewModel.users[2].name
        nameCombineLabel.text = viewModel.users[3].name

        addressDelegateLabel.text = viewModel.users[0].address
        addressClosureLabel.text = viewModel.users[1].address
        addressNotificationLabel.text = viewModel.users[2].address
        addressCombineLabel.text = viewModel.users[3].address
    }

    @IBAction func editUserButtonTouchUpInside(_ sender: UIButton) {
        let vc = EditViewController()
        switch sender.tag {
        case 0:
            // Delegate
            vc.viewModel = viewModel.viewModelForEdit(editType: .delegate)
            vc.delegate = self
        case 1:
            // Closure
            vc.viewModel = viewModel.viewModelForEdit(editType: .closure)
            vc.closure = { [weak self] user in
                guard let this = self else { return }
                this.viewModel.users[1] = user
                this.updateView()
            }
        case 2:
            // Notification
            vc.viewModel = viewModel.viewModelForEdit(editType: .notification)
        default:
            // Combine
            vc.viewModel = viewModel.viewModelForEdit(editType: .combine)
            HomeViewController.userInput.sink { [weak self] (user) in
                guard let this = self else { return }
                this.viewModel.users[3] = user
                this.updateView()
            }
            .store(in: &subscriptions)
        }

        present(vc, animated: true, completion: nil)
    }

    // Notification
    @objc private func updateDataNotif(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            viewModel.users[2] = user
            updateView()
        }
    }
}

// MARK: - EditViewControllerDelegate
extension HomeViewController: EditViewControllerDelegate {
    func view(_ view: EditViewController, needPerformAction action: EditViewController.Action) {
        switch action {
        case .updateUser(let user):
            viewModel.users[0] = user
            updateView()
        }
    }
}

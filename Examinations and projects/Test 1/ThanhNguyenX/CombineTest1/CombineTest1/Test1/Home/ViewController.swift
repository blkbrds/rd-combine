//
//  ViewController.swift
//  CombineTest1
//
//  Created by Thanh Nguyen X. on 02/26/21.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    @IBOutlet weak var nameDelegateLabel: UILabel!
    @IBOutlet weak var addressDelegateLabel: UILabel!

    @IBOutlet weak var nameClosureLabel: UILabel!
    @IBOutlet weak var addressClosureLabel: UILabel!

    @IBOutlet weak var nameNotifLabel: UILabel!
    @IBOutlet weak var addressNotifLabel: UILabel!

    @IBOutlet weak var nameCombineLabel: UILabel!
    @IBOutlet weak var addressCombineLabel: UILabel!

    var viewModel: HomeViewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateWithNotification(notification:)),
                                               name: Notification.Name.notification, object: nil)
    }

    @objc private func updateWithNotification(notification: NSNotification) {
        if let human = notification.userInfo?["human"] as? Human {
            viewModel.humanNotification = human
            nameNotifLabel.text = viewModel.humanNotification.name
            addressNotifLabel.text = viewModel.humanNotification.address
        }
    }

    private func configData() {
        nameDelegateLabel.text = viewModel.humanDelegate.name
        addressDelegateLabel.text = viewModel.humanDelegate.address

        nameClosureLabel.text = viewModel.humanClosure.name
        addressClosureLabel.text = viewModel.humanClosure.address

        nameNotifLabel.text = viewModel.humanNotification.name
        addressNotifLabel.text = viewModel.humanNotification.address

        nameCombineLabel.text = AppDelegate.shared.humanCombine.value.name
        addressCombineLabel.text = AppDelegate.shared.humanCombine.value.address
    }

    private func openEditVC() {
        guard let human = viewModel.editShowData else { return }
        let vc: EditViewController = EditViewController()
        vc.delegate = self
        vc.closure = { human in
            self.viewModel.humanClosure = human
            self.nameClosureLabel.text = self.viewModel.humanClosure.name
            self.addressClosureLabel.text = self.viewModel.humanClosure.address
        }
        vc.viewModel = EditViewModel(human: human, editType: viewModel.editType)
        present(vc, animated: true)
    }

    @IBAction func editAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: /// `delegate`
            viewModel.editType = .delegate
            viewModel.editShowData = viewModel.humanDelegate
        case 1: /// `closure`
            viewModel.editType = .closure
            viewModel.editShowData = viewModel.humanClosure
        case 2: /// `notification`
            viewModel.editType = .notification
            viewModel.editShowData = viewModel.humanNotification
        case 3: /// `combine`
            viewModel.editType = .combine
            viewModel.editShowData = AppDelegate.shared.humanCombine.value
            AppDelegate.shared.humanCombine.sink { human in
                self.nameCombineLabel.text = human.name
                self.addressCombineLabel.text = human.address
            }.store(in: &subscriptions)
        default: break
        }
        openEditVC()
    }
}

extension ViewController: EditViewControllerDelegate {
    func view(_ view: EditViewController, needPerform action: EditViewController.Action) {
        switch action {
        case .updateData(let human):
            viewModel.humanDelegate = human
            nameDelegateLabel.text = viewModel.humanDelegate.name
            addressDelegateLabel.text = viewModel.humanDelegate.address
        }
    }
}

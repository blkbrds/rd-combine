//
//  HomeViewController.swift
//  BaiTapCombine
//
//  Created by Trin Nguyen X on 2/28/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var nameLabel: [UILabel]!
    @IBOutlet private var addressLabel: [UILabel]!

    // MARK: - Properties
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBAction
    @IBAction private func editButtonTouchUpInside(_ sender: UIButton) {
        let editVC = EditViewController()
        editVC.viewModel = EditViewModel(name: nameLabel[sender.tag].text ?? "", address: addressLabel[sender.tag].text ?? "", tagNumber: sender.tag)
        switch sender.tag {
        // 1. Delegate
        case 0:
            editVC.delegate = self
        // 2. Closure
        case 1:
            editVC.foo = { [weak self] viewModel in
                guard let this = self else { return }
                this.nameLabel[viewModel.tagNumber].text = viewModel.name
                this.addressLabel[viewModel.tagNumber].text = viewModel.address
            }
        // 3. Notification
        case 2:
            NotificationCenter.default.addObserver(self, selector: #selector(updateInfoUser(_:)),
                                                   name: .updateInfoUser, object: nil)
        // 4. Combine
        default:
            editVC.publisher.sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (value) in
                self.nameLabel[value.tagNumber].text = value.name
                self.addressLabel[value.tagNumber].text = value.address
            }.store(in: &subscriptions)
        }
        present(editVC, animated: true, completion: nil)
    }

    // MARK: - Objc functions
    @objc private func updateInfoUser(_ notification: Notification) {
        guard let viewModel = notification.object as? EditViewModel else {
            return
        }
        nameLabel[viewModel.tagNumber].text = viewModel.name
        addressLabel[viewModel.tagNumber].text = viewModel.address
    }
}

// MARK: - Extension
extension HomeViewController: EditViewControllerDelegate {
    func updateInfoUser(_ view: EditViewController, needsPerform action: EditViewController.Action) {
        switch action {
        case .send(let name, let address,let tag):
            nameLabel[tag].text = name
            addressLabel[tag].text = address
        }
    }
}

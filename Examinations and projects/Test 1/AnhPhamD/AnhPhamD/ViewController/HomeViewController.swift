//
//  HomeViewController.swift
//  AnhPhamD
//
//  Created by AnhPhamD. [2] on 2/25/21.
//  Copyright © 2021 AnhPhamD. [2]. All rights reserved.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet private var namesLabel: [UILabel]!
    @IBOutlet private var addressLabel: [UILabel]!

    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func editButtonTouchUpInSide(_ sender: UIButton) {
        let editVC = EditViewController()
        editVC.viewModel = EditViewModel(name: namesLabel[sender.tag].text ?? "", address: addressLabel[sender.tag].text ?? "", tagNumber: sender.tag)
        switch sender.tag {
            case 0:
                print("Delegate")
                editVC.delegate = self
            case 1:
                print("Closure")
                editVC.foo = { [weak self] value in
                    guard let this = self else { return }
                    this.namesLabel[value.tagNumber].text = value.name
                    this.addressLabel[value.tagNumber].text = value.address
            }
            case 2:
                print("Notification")
                NotificationCenter.default.addObserver(self, selector: #selector(updateInformation), name: .updateInformation, object: nil)
            case 3:
                print("Combine")
                editVC.passthroughSubject.sink(receiveCompletion: { (completion) in
                    print(completion)
                }) { (value) in
                    self.namesLabel[value.tagNumber].text = value.name
                    self.addressLabel[value.tagNumber].text = value.address
                }.store(in: &subscriptions)
            default: break
        }
        present(editVC, animated: true)
    }
    
    @objc func updateInformation(_ notification: Notification) {
        guard let viewModel = notification.object as? EditViewModel else { return }
        namesLabel[viewModel.tagNumber].text = viewModel.name
        addressLabel[viewModel.tagNumber].text = viewModel.address
    }
}

extension HomeViewController: EditViewControllerDelegate {
    func sendInfo(_ view: EditViewController, needsPerform action: EditViewController.Action) {
        switch action {
        case .send(let name, let address,let tag):
            namesLabel[tag].text = name
            addressLabel[tag].text = address
        }
    }
}

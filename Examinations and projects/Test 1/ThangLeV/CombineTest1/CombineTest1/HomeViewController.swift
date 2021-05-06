//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by MBA0183 on 2/26/21.
//

import UIKit
import Combine

enum CodingStyle {
    case delegate
    case closure
    case notification
    case combine
    
    var codingStyleTag: Int {
        switch self {
        case .delegate:
            return 1
        case .closure:
            return 2
        case .notification:
            return 3
        case .combine:
            return 4
        }
    }
}

class HomeViewController: BaseViewController {
    
    @IBOutlet var userNameLabelCollection: [UILabel]!
    @IBOutlet var addressLabelCollection: [UILabel]!
    
    var codingStyle: CodingStyle = .delegate
    var subscriptions = Set<AnyCancellable>()
    
    func updateText(userName: String, address: String) {
        for label in self.userNameLabelCollection {
            if label.tag == self.codingStyle.codingStyleTag {
                label.text = userName
            }
        }
        for label in self.addressLabelCollection {
            if label.tag == self.codingStyle.codingStyleTag {
                label.text = address
            }
        }
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let userName = notification.userInfo?["userName"] as? String,
              let address = notification.userInfo?["address"] as? String else { return }
        updateText(userName: userName, address: address)
        NotificationCenter.default.removeObserver(self, name: .myNotificationKey, object: nil)
    }
    
    @IBAction func editButtonTouchUpInside(_ sender: UIButton) {
        let vc: EditViewController = EditViewController()
        switch sender.tag {
        case 1:
            // Delegate
            codingStyle = .delegate
            vc.delegate = self
        case 2:
            //Closure
            codingStyle = .closure
            vc.completionHandler = { userName, address in
                self.updateText(userName: userName, address: address)
            }
        case 3:
            // Notification
            codingStyle = .notification
            NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: .myNotificationKey, object: nil)
        case 4:
            // Combine
            codingStyle = .combine
            vc.passthroughSubject
                .collect()
                .sink(receiveCompletion: { _ in
            }, receiveValue: { value in
                self.updateText(userName: value[0], address: value[1])
            }).store(in: &subscriptions)
        default:
            codingStyle = .delegate
        }
        present(vc, animated: true)
    }
}

extension HomeViewController: EditViewControllerDelegate {
    func passDataBackToHome(userName: String, address: String) {
        updateText(userName: userName, address: address)
    }
}

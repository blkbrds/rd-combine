//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by Tran Van Tien on R 3/02/28.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    @IBOutlet private weak var nameDelegateLabel: UILabel!
    @IBOutlet private weak var addressDelegateLabel: UILabel!

    @IBOutlet private weak var nameClosureLabel: UILabel!
    @IBOutlet private weak var addressClosureLabel: UILabel!

    @IBOutlet private weak var nameNotiLabel: UILabel!
    @IBOutlet private weak var addressNotiLabel: UILabel!

    @IBOutlet private weak var nameCombineLabel: UILabel!
    @IBOutlet private weak var addressCombineLabel: UILabel!

    // 4. combine
    private var subscriptions: Set<AnyCancellable> = []
//    static let editUser = CurrentValueSubject<User, Never>(User(name: "", address: ""))
    static let editUser = PassthroughSubject<User, Never>()

    private var users: [User] = [
        User(name: "ミラーさん", address: "アメリカ"),
        User(name: "ティエン", address: "ベトナム"),
        User(name: "シューミットさん", address: "イギリス"),
        User(name: "りーさん", address: "中国")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, user) in users.enumerated() {
            if let type = EditType(rawValue: index) {
                updateView(type: type, user: user)
            }
        }
        // 3. notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(_:)), name: .kNotification, object: nil)
    }

    @objc private func updateView(_ notification: NSNotification) {
        guard let user = notification.object as? User else { return }
        updateView(type: .notification, user: user, isEdit: true)
    }

    @IBAction private func editUserTouchUpInside(_ sender: UIButton) {
        let tag = sender.tag
        guard (0...3).contains(tag), let type = EditType(rawValue: tag) else { return }
        let vc = DetailViewController()
        vc.user = users[tag]
        vc.type = type
        switch type {
        case .delegate:
            // 1. delegate
            vc.delegate = self
        case .closure:
            // 2. closure
            vc.closure = ({ (user) in
                self.updateView(type: .closure, user: user, isEdit: true)
            })
        case .notification:
            // 3. notification
            break
        case .combine:
            // 4. combine
            HomeViewController.editUser
                .sink(receiveCompletion: {
                    print("🐳receiveCompletion: \($0)")
                }, receiveValue: { user in
                    print("🐳receiveValue: \(user)")
                    self.updateView(type: .combine, user: user, isEdit: true)
                })
                .store(in: &subscriptions)
        }
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: DetailViewControllerDelegate {
    func viewController(_ viewController: DetailViewController, needsPerform action: DetailViewController.Action) {
        switch action {
        case .doneDelegate(let user):
            updateView(type: .delegate, user: user, isEdit: true)
        }
    }
}

extension HomeViewController {

    func updateView(type: EditType, user: User, isEdit: Bool = false) {
        switch type {
        case .delegate:
            nameDelegateLabel.text = user.name
            addressDelegateLabel.text = user.address
        case .closure:
            nameClosureLabel.text = user.name
            addressClosureLabel.text = user.address
        case .notification:
            nameNotiLabel.text = user.name
            addressNotiLabel.text = user.address
        case .combine:
            nameCombineLabel.text = user.name
            addressCombineLabel.text = user.address
        }
        if isEdit {
            users[type.rawValue] = user
        }
    }

    enum EditType: Int {
        case delegate = 0
        case closure
        case notification
        case combine
    }

    struct User {
        var name: String
        var address: String
    }
}

extension NSNotification.Name {
    static let kNotification = NSNotification.Name("kNotification")
}

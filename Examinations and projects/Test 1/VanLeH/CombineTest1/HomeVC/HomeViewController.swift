//
//  ViewController.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/18/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    @IBOutlet weak var userViewDelegate: UserViewDelegateWay!
    @IBOutlet weak var userViewClosure: UserViewClosureWay!
    @IBOutlet weak var userViewNotification: UserViewNotificationWay!
    @IBOutlet weak var userViewCombine: UserViewCombineWay!

    var viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        // 1. Delegate
        userViewDelegate.viewModel = viewModel.viewModelForUserView(wayIndex: AsynchronousWay.delegate.rawValue)
        userViewDelegate.delegate = self

        // 2. Closure
        userViewClosure.viewModel = viewModel.viewModelForUserView(wayIndex: AsynchronousWay.closure.rawValue)
        userViewClosure.goToEdit = { [weak self] userAtIndex in
            self?.goToEditVC(with: userAtIndex)
        }

        // 3. Notification
        userViewNotification.viewModel = viewModel.viewModelForUserView(wayIndex: AsynchronousWay.notification.rawValue)
        NotificationCenter.default.addObserver(forName: Notification.Name("goToEdit"), object: nil, queue: nil) { [weak self] noti in
            guard let userAtIndex = noti.userInfo?["userAtIndex"] as? Int else { return }
            self?.goToEditVC(with: userAtIndex)
        }

        // 4. Combine
        userViewCombine.viewModel = viewModel.viewModelForUserView(wayIndex: AsynchronousWay.combine.rawValue)
    }

    private func goToEditVC(with userAtIndex: Int) {
//        let user = viewModel.users[userAtIndex]
    }
}

extension HomeViewController: UserViewDelegate {
    func view(_ view: UserViewDelegateWay, needPerforms action: UserViewDelegateWay.Action) {
        switch action {
        case .goToEdit(let userAtIndex):
            goToEditVC(with: userAtIndex)
        }
    }
}

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
    
    private var subscription = Set<AnyCancellable>()

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
        NotificationCenter.default.addObserver(forName: Notification.Name("didEditUser"), object: nil, queue: nil) { [weak self] noti in
            guard let newUser = noti.userInfo?["newUser"] as? User,
                  let self = self else { return }
            self.viewModel.users[AsynchronousWay.notification.rawValue] = newUser
            self.userViewNotification.viewModel = self.viewModel.viewModelForUserView(wayIndex: AsynchronousWay.notification.rawValue)
        }

        // 4. Combine
        userViewCombine.viewModel = viewModel.viewModelForUserView(wayIndex: AsynchronousWay.combine.rawValue)
        userViewCombine.goToEditAction
            .sink { [weak self] userAtIndex in
                self?.goToEditVC(with: userAtIndex)
            }
            .store(in: &subscription)
    }

    private func goToEditVC(with userAtIndex: Int) {
        guard let way = AsynchronousWay(rawValue: userAtIndex) else { return }
        switch way {
        case .delegate:
            let vc = EditVCDelegateWay()
            vc.viewModel = viewModel.viewModelForEditVC(wayIndex: userAtIndex)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .closure:
            let vc = EditVCClosureWay()
            vc.viewModel = viewModel.viewModelForEditVC(wayIndex: userAtIndex)
            vc.didEdit = { [weak self] newUser in
                guard let self = self else { return }
                self.viewModel.users[userAtIndex] = newUser
                self.userViewClosure.viewModel = self.viewModel.viewModelForUserView(wayIndex: AsynchronousWay.closure.rawValue)
            }
            present(vc, animated: true, completion: nil)
        case .notification:
            let vc = EditVCNotificationWay()
            vc.viewModel = viewModel.viewModelForEditVC(wayIndex: userAtIndex)
            present(vc, animated: true, completion: nil)
        case .combine:
            let vc = EditVCCombineWay()
            vc.viewModel = viewModel.viewModelForEditVC(wayIndex: userAtIndex)
            guard let vm = vc.viewModel as? EditViewModelCombineWay else { return }
            vm.userSubject
                .sink { [weak self] newUser in
                    guard let self = self else { return }
                    self.viewModel.users[userAtIndex] = newUser
                    self.userViewCombine.viewModel = self.viewModel.viewModelForUserView(wayIndex: AsynchronousWay.combine.rawValue)
                }
                .store(in: &subscription)
            present(vc, animated: true, completion: nil)
        }
    }
}

// 1. Delegate
extension HomeViewController: UserViewDelegate {
    func view(_ view: UserViewDelegateWay, needPerforms action: UserViewDelegateWay.Action) {
        switch action {
        case .goToEdit(let userAtIndex):
            goToEditVC(with: userAtIndex)
        }
    }
}


extension HomeViewController: EditViewControllerDelegate {
    func viewController(_ viewController: EditViewController, needPerforms action: EditVCDelegateWay.Action) {
        switch action {
        case .didEdit(let newUser):
            viewModel.users[viewController.view.tag] = newUser
            userViewDelegate.viewModel = viewModel.viewModelForUserView(wayIndex: AsynchronousWay.delegate.rawValue)
        }
    }
}

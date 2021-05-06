//
//  ContentVC.swift
//  CombineTest1
//
//  Created by MBA0288F on 2/26/21.
//

import UIKit
import Combine

final class ContentVC: UIViewController {
        
    // MARK: - IBOutlet
    
    @IBOutlet private weak var delegateView: DetailView!
    @IBOutlet private weak var closureView: DetailView!
    @IBOutlet private weak var notificationView: DetailView!
    @IBOutlet private weak var combineView: DetailView!
    
    var viewModel = ContentVM()
    
    var subcriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDelegateView()
        configClosureView()
        configNotificationView()
        configCombineView()
    }
    
    // 1. Delegate
    private func configDelegateView() {
        delegateView.viewModel = DetailViewVM(user: viewModel.delegateUserInfo, type: .delegate)
        delegateView.delegate = self
    }
    
    // 2. Closure
    private func configClosureView() {
        closureView.viewModel = DetailViewVM(user: viewModel.closureUserInfo, type: .closure)
        closureView.moveEdit = { [weak self] in
            guard let this = self else { return }
            this.moveToEdit(type: .closure)
        }
    }
    
    // 3. Notification
    private func configNotificationView() {
        notificationView.viewModel = DetailViewVM(user: viewModel.notificationUserInfo, type: .notification)
        NotificationCenter.default.addObserver(self, selector: #selector(moveEditIncaseNotification), name: .moveEdit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditSuccess), name: .editSuccess, object: nil)
        
    }
    
    // 4. Combine
    private func configCombineView() {
        viewModel.combineUserInfo.sink { [weak self] (userInfo) in
            guard let this = self else { return }
            this.combineView.viewModel = DetailViewVM(user: userInfo, type: .combine)
        }.store(in: &subcriptions)
        
        combineView.actionSubject.sink(receiveValue: { [weak self] (action) in
            guard let this = self else { return }
            switch action {
            case .moveEdit:
                this.moveToEdit(type: .combine)
            }
        }).store(in: &subcriptions)
    }
}

// MARK: - Action

extension ContentVC {
    
    // 3. Notification
    @objc func moveEditIncaseNotification() {
        moveToEdit(type: .notification)
    }
    
    // 3. Notification
    @objc func handleEditSuccess(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let name = userInfo["name"] as? String,
              let address = userInfo["address"] as? String else { return }
        viewModel.notificationUserInfo = UserInfomation(name: name, address: address)
        notificationView.viewModel = DetailViewVM(user: viewModel.notificationUserInfo, type: .notification)
    }
    
    private func moveToEdit(type: ViewType) {
        let vc = EditVC()
        switch type {
        case .delegate:
            vc.viewModel = EditVM(userInfo: viewModel.delegateUserInfo, type: .delegate)
            vc.delegate = self
        case .closure:
            vc.viewModel = EditVM(userInfo: viewModel.closureUserInfo, type: .closure)
            vc.closureUserInfo = { [weak self] userInfo in
                guard let this = self else { return }
                this.viewModel.closureUserInfo = userInfo
                this.closureView.viewModel = DetailViewVM(user: userInfo, type: .closure)
            }
        case .notification:
            vc.viewModel = EditVM(userInfo: viewModel.notificationUserInfo, type: .notification)
        case .combine:
            vc.viewModel = EditVM(userInfo: viewModel.combineUserInfo.value, type: .combine)
            vc.viewModel.userInfoCombine.sink(receiveValue: { [weak self] (userInfo) in
                guard let this = self else { return }
                this.viewModel.combineUserInfo.send(userInfo)
            }).store(in: &subcriptions)
        }
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - DetailViewDelegate

// 1. Delegate
extension ContentVC: DetailViewDelegate {
    
    func view(_view: DetailView, needPerforms action: DetailView.Action) {
        moveToEdit(type: .delegate)
    }
}

// MARK: - EditVCDelegate

// 1. Delegate
extension ContentVC: EditVCDelegate {
    
    func viewController(_viewController: EditVC, needPerforms action: EditVC.Action) {
        switch action {
        case .done(let userInfo):
            viewModel.delegateUserInfo = userInfo
            delegateView.viewModel = DetailViewVM(user: viewModel.delegateUserInfo, type: .delegate)
        }
    }
}

final class ContentVM {
    var delegateUserInfo: UserInfomation = UserInfomation(name: "AAAAAAA", address: "aaaaaaa")
    var closureUserInfo: UserInfomation = UserInfomation(name: "BBBBBBB", address: "bbbbbbb")
    var notificationUserInfo: UserInfomation = UserInfomation(name: "CCCCCCC", address: "ccccccc")
    var combineUserInfo: CurrentValueSubject<UserInfomation, Never> = CurrentValueSubject<UserInfomation, Never>(UserInfomation(name: "DDDDDDD", address: "ddddddd"))
}

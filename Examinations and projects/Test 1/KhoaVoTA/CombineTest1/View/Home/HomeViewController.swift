//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 2/28/21.
//

import UIKit
import Combine

final class HomeViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var delegateInfoView: InfoView!
    @IBOutlet private weak var closureInfoView: InfoView!
    @IBOutlet private weak var notificationInfoView: InfoView!
    @IBOutlet private weak var combineInfoView: InfoView!

    // MARK: - Properties
    var viewModel: HomeViewModel?

    // 4. Combine
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        // 3. Notfication
        addObserver()
    }

    // MARK: - Private func
    private func configView() {
        // 1. Delegate
        configDelegateInfoView()

        // 2. Closure
        configClosureInfoView()

        // 3. Notification
        configNotificationInfoView()

        // 4. Combine
        configCombineInfoView()
    }

    // 1. Delegate
    private func configDelegateInfoView() {
        guard let viewModel = viewModel else { return }
        delegateInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .delegate)
        delegateInfoView.delegate = self
    }

    // 2. Closure
    private func configClosureInfoView() {
        guard let viewModel = viewModel else { return }
        closureInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .closure)
        closureInfoView.moveToEditCompletion = { [weak self] in
            guard let this = self else { return }
            this.moveToEdit(viewType: .closure)
        }
    }

    // 3. Notification
    private func configNotificationInfoView() {
        guard let viewModel = viewModel else { return }
        notificationInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .notification)
    }

    // 4. Combine
    private func configCombineInfoView() {
        guard let viewModel = viewModel else { return }
        combineInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .combine)
        combineInfoView.subject.sink(receiveValue: { [weak self] action in
            guard let this = self else { return }
            switch action {
            case .moveToEdit:
                this.moveToEdit(viewType: .combine)
            }
        }).store(in: &subscriptions)
    }

    // 3. Notification
    private func addObserver() {
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(handleMoveToEdit), name: .moveToEdit, object: nil)
        center.addObserver(self, selector: #selector(handleUpdateInfoView), name: .updateInfo, object: nil)
    }

    // 3. Notification
    @objc private func handleMoveToEdit(_ notification: Notification) {
        moveToEdit(viewType: .notification)
    }

    // 3. Notification
    @objc private func handleUpdateInfoView(_ notification: Notification) {
        guard let viewModel = viewModel, let info: Info = notification.object as? Info else {
            return
        }
        viewModel.updateInfo(viewType: .notification, info: info)
        updateInfoView(viewType: .notification)
    }

    private func moveToEdit(viewType: InfoViewType) {
        guard let viewModel = viewModel else { return }
        let vc = EditViewController()
        vc.delegate = self
        vc.viewModel = viewModel.viewModeForEdit(fromViewType: viewType)

        // 2. Closure
        vc.updateInfoCompletion = { [weak self] info in
            guard let this = self else { return }
            viewModel.updateInfo(viewType: .closure, info: info)
            this.updateInfoView(viewType: .closure)
        }

        // 4. Combine
        vc.subject.sink(receiveValue: { [weak self] info in
            guard let this = self else { return }
            viewModel.updateInfo(viewType: .combine, info: info)
            this.updateInfoView(viewType: .combine)
        }).store(in: &subscriptions)

        present(vc, animated: true, completion: nil)
    }

    private func updateInfoView(viewType: InfoViewType) {
        guard let viewModel = viewModel else { return }
        switch viewType {
        case .delegate:
            delegateInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .delegate)
        case .closure:
            closureInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .closure)
        case .notification:
            notificationInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .notification)
        case .combine:
            combineInfoView.viewModel = viewModel.viewModelForInfoView(viewType: .combine)
        }
    }
}

// MARK: - InfoViewDelegate
// 1. Delegate
extension HomeViewController: InfoViewDelegate {
    func view(_ view: InfoView, needsPerform action: InfoView.Action) {
        switch action {
        case .moveToEdit:
            moveToEdit(viewType: .delegate)
        }
    }
}

// MARK: - EditViewControllerDelegate
// 1. Delegate
extension HomeViewController: EditViewControllerDelegate {
    func controller(_ controller: EditViewController, needsPerform action: EditViewController.Action) {
        switch action {
        case .updateInfo(info: let info):
            guard let viewModel = viewModel else { return }
            viewModel.updateInfo(viewType: .delegate, info: info)
            updateInfoView(viewType: .delegate)
        }
    }
}

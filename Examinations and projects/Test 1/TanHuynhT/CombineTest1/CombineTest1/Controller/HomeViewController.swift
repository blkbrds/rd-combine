//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by TanHuynh on 2021/02/28.
//

import UIKit
import Combine

let kUpdateInfor = "kUpdateInfor"

protocol HomeViewControllerDelegate: class {

    func controller(controller: UIViewController, needPerform action: HomeViewController.Action)
}

class HomeViewController: UIViewController {

    enum Action {
        case updateInfor(viewModel: EditInforViewModel)
    }

    enum TranferType: Int {
        case delegate = 0
        case closure = 1
        case notification = 2
        case combine = 3
    }

    @IBOutlet private var nameLabels: [UILabel]!
    @IBOutlet private var addressLabels: [UILabel]!

    private var subscriptions = Set<AnyCancellable>()

    deinit {
        subscriptions.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func updateInfor(viewModel: EditInforViewModel) {
        let tag = viewModel.type.rawValue
        nameLabels[tag].text = viewModel.name
        addressLabels[tag].text = viewModel.address
    }

    @objc private func updateInforNotif(_ notification: Notification) {
        guard let viewModel = notification.object as? EditInforViewModel else {
            return
        }
        updateInfor(viewModel: viewModel)
    }

    @IBAction private func editInforButtonTouchUpInside(_ sender: UIButton) {
            // 1 - delegate, 2 - closure, 3 - notification, 4 - combine
            let tag: Int = sender.tag
            guard let type = TranferType.init(rawValue: tag) else { return }

            let vc = EditInforViewController()
            vc.viewModel = EditInforViewModel(type: type)

            switch type {
            case .delegate:
                vc.delegate = self
            case .closure:
                vc.updateInfor = { [weak self] viewModel in
                    guard let this = self else { return }
                    this.updateInfor(viewModel: viewModel)
                }
            case .notification:
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(updateInforNotif),
                                                       name: NSNotification.Name(rawValue: kUpdateInfor),
                                                       object: nil)
            case .combine:
                vc.publisher = PassthroughSubject<EditInforViewModel, Never>()
                vc.publisher?.sink { (completion) in
                    print("Completion: \(completion)")
                } receiveValue: { [weak self] viewModel in
                    guard let this = self else { return }
                    this.updateInfor(viewModel: viewModel)
                }.store(in: &subscriptions)
            }

            present(vc, animated: true, completion: nil)
        }
}

extension HomeViewController: HomeViewControllerDelegate {

    func controller(controller: UIViewController, needPerform action: Action) {
        switch action {
        case .updateInfor(let viewModel):
            updateInfor(viewModel: viewModel)
        }
    }
}

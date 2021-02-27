//
//  ViewController.swift
//  CombineTest1
//
//  Created by MBA0283F on 2/26/21.
//

import UIKit
import Combine

// 1. Delegate
protocol HomeViewControllerDelegate: class {
    func homeViewController(vc: UIViewController, perform action: HomeViewController.Action)
}

final class HomeViewController: UIViewController {

    @IBOutlet private var editButtons: [UIButton]!
    @IBOutlet private var usernameLabels: [UILabel]!
    @IBOutlet private var addressLabels: [UILabel]!
    
    // 1. Delegate
    enum Action {
        case editInfo
    }
    
    // 4. Combine
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButtons.forEach({ $0.titleLabel?.textAlignment = .center })
    }

    @IBAction private func editUserButton(_ sender: UIButton) {
        // for tag: 0-delegate, 1-closure, 2-notification, 3-combine
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tag: Int = sender.tag
        guard let editInfoVC = storyboard.instantiateViewController(identifier: "editInfoVC") as? EditInfoViewController else {
            return
        }
        editInfoVC.viewModel = EditInfoViewModel(tag: tag)
        switch tag {
        // 1. Delegate
        case 0:
            editInfoVC.delegate = self
        // 2. Closure
        case 1:
            editInfoVC.editInfo = { [weak self] viewModel in
                self?.updateInfo(viewModel)
            }
        // 3. Notification
        case 2:
            NotificationCenter.default.addObserver(self, selector: #selector(editInfoNoti),
                                                   name: .didReceiveInfo, object: nil)
        // 4. Combine
        default:
            editInfoVC.viewModelPublisher = PassthroughSubject<EditInfoViewModel, Never>()
            editInfoVC.viewModelPublisher?.sink { (completion) in
                print(completion)
            } receiveValue: { [weak self] (viewModel) in
                self?.updateInfo(viewModel)
            }.store(in: &subscriptions)
        }
        present(editInfoVC, animated: true, completion: nil)
    }
    
    @objc private func editInfoNoti(_ notification: Notification) {
        guard let viewModel = notification.object as? EditInfoViewModel else {
            return
        }
        updateInfo(viewModel)
    }
    
    private func updateInfo(_ viewModel: EditInfoViewModel) {
        usernameLabels[safeIndex: viewModel.tag]?.text = viewModel.username
        addressLabels[safeIndex: viewModel.tag]?.text = viewModel.address
    }
    
}

extension HomeViewController: HomeViewControllerDelegate {
    func homeViewController(vc: UIViewController, perform action: Action) {
        guard let vc = vc as? EditInfoViewController else { return }
        updateInfo(vc.viewModel)
    }
}

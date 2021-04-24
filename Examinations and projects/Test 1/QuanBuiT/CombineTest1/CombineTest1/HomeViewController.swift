//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by MBA0253P on 2/28/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    @IBOutlet private var nameLabels: [UILabel]!
    @IBOutlet private var addressLabels: [UILabel]!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func editButtonTouchUpInside(_ sender: UIButton) {
        let editVC = EditViewController()
        editVC.viewModel = EditViewModel(name: nameLabels[sender.tag].text ?? "", address: addressLabels[sender.tag].text ?? "", tagEdit: sender.tag)
        switch sender.tag {
        // 1. Delegate
        case 0:
            editVC.delegate = self
        // 2. Closure
        case 1:
            editVC.foo = { [weak self] viewModel in
                self?.nameLabels[viewModel.tagEdit].text = viewModel.name
                self?.addressLabels[viewModel.tagEdit].text = viewModel.address
            }
        // 3. Notification
        case 2:
            NotificationCenter.default.addObserver(self, selector: #selector(editDataUser),
                                                   name: .updateDataUser, object: nil)
        // 4. Combine
        default:
            editVC.publisher = PassthroughSubject<(String, String, Int), Never>()
            editVC.publisher?.sink { (completion) in
                print(completion)
            } receiveValue: { [weak self] (value) in
                self?.nameLabels[value.2].text = value.0
                self?.addressLabels[value.2].text = value.1
            }.store(in: &subscriptions)
        }
        present(editVC, animated: true, completion: nil)
    }
    
    @objc private func editDataUser(_ notification: Notification) {
        guard let viewModel = notification.object as? EditViewModel else {
            return
        }
        nameLabels[viewModel.tagEdit].text = viewModel.name
        addressLabels[viewModel.tagEdit].text = viewModel.address
    }
}

extension HomeViewController: EditViewControllerDelegate {
    func updateDataUser(_ controller: EditViewController, data: (String, String, Int)) {
        nameLabels[data.2].text = data.0
        addressLabels[data.2].text = data.1
    }
}


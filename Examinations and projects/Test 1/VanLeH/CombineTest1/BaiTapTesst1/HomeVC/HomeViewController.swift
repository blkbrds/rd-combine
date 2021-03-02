//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/1/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var addressDelegateLabel: UILabel!
    @IBOutlet private weak var nameDelegateLabel: UILabel!
    @IBOutlet private weak var editDelegateButton: UIButton!
    @IBOutlet private weak var editClosureButton: UIButton!
    @IBOutlet private weak var editNotificationButton: UIButton!
    @IBOutlet private weak var editCombineButton: UIButton!
    
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configUI() {
        editDelegateButton.setAllStatesTitle("Edit\n(Delegate)")
        editClosureButton.setAllStatesTitle("Edit\n(Closure)")
        editNotificationButton.setAllStatesTitle("Edit\n(Notification)")
        editCombineButton.setAllStatesTitle("Edit\n(Combine)")
        
    }
    
    @IBAction func editDelegateTouchUpInside(_ sender: Any) {
        let vc = EditViewController()
        vc.typeOfUse = .editDelegate
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func editClosureTouchUpInside(_ sender: Any) {
        let vc = EditViewController()
        vc.typeOfUse = .editClosure
        if let viewModel = viewModel {
            vc.viewModel = viewModel.viewModelForEdit()
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func editNotificationTouchUpInside(_ sender: Any) {
        let vc = EditViewController()
        vc.typeOfUse = .editNotification
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func editCombineTouchUpInside(_ sender: Any) {
        let vc = EditViewController()
        vc.typeOfUse = .editCombine
        self.present(vc, animated: false, completion: nil)
    }
}

extension HomeViewController: EditViewControllerDelegate {
    func viewController(_ viewController: EditViewController, needPerforms action: EditViewController.Action) {
        switch action {
        case .updateUser(let user):
            nameDelegateLabel.isHidden = false
            addressDelegateLabel.isHidden = false
            nameDelegateLabel.text = user.name
            addressDelegateLabel.text = user.address
        default:
            break
        }
    }
}

//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/1/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var editDelegateButton: UIButton!
    @IBOutlet private weak var editClosureButton: UIButton!
    @IBOutlet private weak var editNotificationButton: UIButton!
    @IBOutlet private weak var editCombineButton: UIButton!
    
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
        let vc = EditViewController()
        self.present(vc, animated: false, completion: nil)
    }
}

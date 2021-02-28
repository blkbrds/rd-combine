//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by NganHa on 28/02/2021.
//

import UIKit
import Combine

enum EditCase {
    case delegate
    case closure
    case notification
    case combine
}

final class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var secondNameLabel: UILabel!
    @IBOutlet private weak var thirdNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var firstAddressLabel: UILabel!
    @IBOutlet private weak var secondAddressLabel: UILabel!
    @IBOutlet private weak var thirdAddressLabel: UILabel!
    @IBOutlet private weak var lastAddressLabel: UILabel!
    @IBOutlet private weak var delegateButton: UIButton!
    @IBOutlet private weak var closureButton: UIButton!
    @IBOutlet private weak var notificationButton: UIButton!
    @IBOutlet private weak var combineButton: UIButton!
    
    // MARK: - Propeties
    var editCase: EditCase = .delegate
    // MARK: - Initialize
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    // MARK: - Override functions
    
    // MARK: - Private functions
    private func setUpButton(_ button: UIButton) {
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }

    private func setUpUI() {
        setUpButton(delegateButton)
        setUpButton(closureButton)
        setUpButton(notificationButton)
        setUpButton(combineButton)
    }

    private func moveToEditViewController(_ button: UIButton) {
        let vc = EditViewController()
        switch button {
        case delegateButton:
            editCase = .delegate
        case closureButton:
            editCase = .closure
        case notificationButton:
            editCase = .notification
        case combineButton:
            editCase = .combine
        default:
            break
        }
        vc.modalPresentationStyle = .formSheet
        vc.viewModel = EditViewModel(editCase: editCase)
        present(vc, animated: true, completion: nil)
    }

    // MARK: - Public functions
    
    // MARK: - Objc functions
    
    // MARK: - IBActions
    @IBAction private func editButtonTouchUpInside(_ sender: UIButton) {
        moveToEditViewController(sender)
    }

}

extension HomeViewController {
}

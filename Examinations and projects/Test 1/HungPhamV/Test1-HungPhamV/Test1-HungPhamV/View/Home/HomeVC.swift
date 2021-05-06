//
//  HomeVC.swift
//  HungPhamV
//
//  Created by Hung Pham V. on 2/25/21.
//

import UIKit
import Combine

final class HomeVC: UIViewController {

    // MARK: - Properties
    var subcriptions = Set<AnyCancellable>()

    // MARK: - OutLet
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var firstAddress: UILabel!
    @IBOutlet weak var firstButton: UIButton!

    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var secondAddress: UILabel!
    @IBOutlet weak var secondButton: UIButton!

    @IBOutlet weak var thirdName: UILabel!
    @IBOutlet weak var thirdAddress: UILabel!
    @IBOutlet weak var thirdButton: UIButton!

    @IBOutlet weak var fourthName: UILabel!
    @IBOutlet weak var fourthAddress: UILabel!
    @IBOutlet weak var fourthButton: UIButton!

    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupData()
    }

    // MARK: - IBAction
    @IBAction func delegateTouchUpInside(_ sender: Any) {
        print("Edit Profile With Using Delegate")
        if let name: String = firstName.text,
           let address: String = firstAddress.text {
            moveToEdit(name: name, address: address, types: .delegate)
        }
    }

    @IBAction func closureTouchUpInside(_ sender: Any) {
        print("Edit Profile With Using Closure")
        if let name: String = secondName.text,
           let address: String = secondAddress.text {
            moveToEdit(name: name, address: address, types: .closure)
        }
    }

    @IBAction func notifTouchUpInside(_ sender: Any) {
        print("Edit Profile With Using Notification")
        if let name: String = thirdName.text,
           let address: String = thirdAddress.text {
            moveToEdit(name: name, address: address, types: .notification)
        }
    }

    @IBAction func combineTouchUpInside(_ sender: Any) {
        print("Edit Profile With Using Combine")
        if let name: String = fourthName.text,
           let address: String = fourthAddress.text {
            moveToEdit(name: name, address: address, types: .combine)
        }
    }

    // MARK: - Private Function
    private func configUI() {
        self.title = "HomeVC"

        firstButton.layer.cornerRadius = 8
        secondButton.layer.cornerRadius = 8
        thirdButton.layer.cornerRadius = 8
        fourthButton.layer.cornerRadius = 8
    }

    private func setupData() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleData(notification:)),
                                               name: .DidEditInfo, object: nil)
    }

    private func moveToEdit(name: String? = nil, address: String? = nil, types: Type) {
        let editVC: EditVC = EditVC()
        editVC.delegate = self
        editVC.viewModel.name = name ?? ""
        editVC.viewModel.address = address ?? ""
        editVC.viewModel.types = types
        editVC.doneCompletion = { (name, address) in
            self.secondName.text = name
            self.secondAddress.text = address
        }
        
        let editNC = UINavigationController(rootViewController: editVC)

        editVC.viewModel.publisher
            .sink(receiveValue: { user in
                self.fourthName.text = user.name
                self.fourthAddress.text = user.address
            })
            .store(in: &subcriptions)
        present(editNC, animated: true, completion: nil)
    }

    @objc private func handleData(notification: Notification) {
        guard let userInfo = notification.object as? UserInfo else { return }
        thirdName.text = userInfo.name
        thirdAddress.text = userInfo.address
    }
}

extension HomeVC: EditVCDelegate {

    func handleEditInfo(_ controller: EditVC, needsPerform action: EditVC.Action) {
        switch action {
        case .edit(name: let newName, address: let newAddress):
            firstName.text = newName
            firstAddress.text = newAddress
        }
    }
}

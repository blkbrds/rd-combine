//
//  HomeViewController.swift
//  Exercise Combine
//
//  Created by MBA0052 on 2/25/21.
//

import UIKit
import Combine

struct User {
    var name: String
    var address: String
}

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel1: UILabel!
    @IBOutlet private weak var nameLabel2: UILabel!
    @IBOutlet private weak var nameLabel3: UILabel!
    @IBOutlet private weak var nameLabel4: UILabel!
    
    @IBOutlet private weak var addressName1: UILabel!
    @IBOutlet private weak var addressName2: UILabel!
    @IBOutlet private weak var addressName3: UILabel!
    @IBOutlet private weak var addressName4: UILabel!
    
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!
    @IBOutlet private weak var button3: UIButton!
    @IBOutlet private weak var button4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButton(button: button1, titleString: "Delegate")
        configButton(button: button2, titleString: "Closure")
        configButton(button: button3, titleString: "Notificaton")
        configButton(button: button4, titleString: "Combine")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataUser(_:)), name: NSNotification.Name(rawValue: HomeViewController.getNotification), object: nil)
    }
    
    static let getNotification = "getNotification"
    var subscriptions = Set<AnyCancellable>()
    //    static let userInput = PassthroughSubject<User, Never>()
    
    private func configButton(button: UIButton, titleString: String) {
        button.layer.cornerRadius = 10
        button.setTitle("Edit\n(\(titleString)", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
    }
    
    @IBAction func movetoDetail(_ sender: UIButton) {
        let viewController = EditViewController()
        switch sender.tag {
        case 0:
            viewController.type = .delegate
        case 1:
            viewController.type = .closure
        case 2:
            viewController.type = .notification
        case 3:
            viewController.type = .combine
            
            viewController.valuePassthrought = PassthroughSubject<EditViewModel, Never>()
            viewController.valuePassthrought?.sink { (viewModel) in
                self.nameLabel4.text = viewModel.name
                self.addressName4.text = viewModel.address
            }
            .store(in: &subscriptions)
        default:
            break
        }
        viewController.delegate = self
        viewController.editInformation = { [weak self] viewModel in
            self?.updateInfo(viewModel)
        }
        present(viewController, animated: true, completion: nil)
    }
    
    private func updateInfo(_ viewModel: EditViewModel) {
        nameLabel2.text = viewModel.name
        addressName2.text = viewModel.address
    }
    
    @objc func updateDataUser(_ notification: NSNotification) {
        guard let name = notification.userInfo?["name"] as? String,
              let address = notification.userInfo?["address"] as? String  else {return}
        nameLabel3.text = name
        addressName3.text = address
    }
}
extension HomeViewController: EditViewControllerDelegate {
    func viewController(_ view: EditViewController, needsPerform action: EditViewController.Action) {
        switch action {
        case .done(let name, let address):
            nameLabel1.text = name
            addressName1.text = address
        }
    }
}

class HomeViewModel {
    enum EditType {
        case delegate
        case closure
        case notification
        case combine
    }
}

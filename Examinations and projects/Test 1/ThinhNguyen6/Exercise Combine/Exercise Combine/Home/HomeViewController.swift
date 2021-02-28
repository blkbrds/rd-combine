//
//  HomeViewController.swift
//  Exercise Combine
//
//  Created by MBA0052 on 2/25/21.
//

import UIKit
import Combine

enum EditType {
    case delegate
    case closure
    case notification
    case combine 
}

struct User {
    var name: String
    var address: String
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var nameLabel4: UILabel!
    
    @IBOutlet weak var addressName1: UILabel!
    @IBOutlet weak var addressName2: UILabel!
    @IBOutlet weak var addressName3: UILabel!
    @IBOutlet weak var addressName4: UILabel!
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataUser(_:)), name: NSNotification.Name(rawValue: HomeViewController.getNotification), object: nil)
    }
    
    static let getNotification = "getNotification"
    var subscriptions = [AnyCancellable]()
    static let userInput = PassthroughSubject<User, Never>()
    
    
    func setupUI() {
        
        button1.layer.cornerRadius = 10
        button2.layer.cornerRadius = 10
        button3.layer.cornerRadius = 10
        button4.layer.cornerRadius = 10
        
        button1.setTitle("Edit\n(Delegate)", for: .normal)
        button1.titleLabel?.lineBreakMode = .byWordWrapping
        button1.titleLabel?.textAlignment = .center
        
        button2.setTitle("Edit\n(Closure)", for: .normal)
        button2.titleLabel?.lineBreakMode = .byWordWrapping
        button2.titleLabel?.textAlignment = .center
        
        button3.setTitle("Edit\n(Notification)", for: .normal)
        button3.titleLabel?.lineBreakMode = .byWordWrapping
        button3.titleLabel?.textAlignment = .center
        
        button4.setTitle("Edit\n(Combine)", for: .normal)
        button4.titleLabel?.lineBreakMode = .byWordWrapping
        button4.titleLabel?.textAlignment = .center
        
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
            HomeViewController.userInput.sink { (user) in
                self.nameLabel4.text = user.name
                self.addressName4.text = user.address
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
        guard let name = notification.userInfo?["name"] as? String  else {return}
        guard let address = notification.userInfo?["address"] as? String  else {return}
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

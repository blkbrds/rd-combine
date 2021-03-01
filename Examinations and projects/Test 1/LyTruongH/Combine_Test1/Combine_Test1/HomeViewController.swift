//
//  HomeViewController.swift
//  Combine_Test1
//
//  Created by Ly Truong H. on 2/27/21.
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
    
    // define
    static let kNotification = "kNotificationCenter"
    
    enum Action {
        case pushView
    }

    @IBOutlet weak var nameDelegateLabel: UILabel!
    @IBOutlet weak var addressDelegateLabel: UILabel!
    
    
    @IBOutlet weak var nameClosureLabel: UILabel!
    @IBOutlet weak var addressClosureLabel: UILabel!
    
    
    @IBOutlet weak var nameNotiLabel: UILabel!
    @IBOutlet weak var addressNotiLabel: UILabel!
    

    @IBOutlet weak var nameCombineLabel: UILabel!
    @IBOutlet weak var addressCombineLabel: UILabel!
    
    var subscriptions = [AnyCancellable]()
    let action = PassthroughSubject<Action, Never>()
    static let userInput = PassthroughSubject<User, Never>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataUser(_:)), name: NSNotification.Name(rawValue: HomeViewController.kNotification), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveToDetail(_ sender: UIButton) {
        let vc = DetailUserViewController()
        switch sender.tag {
        case 0: // delegate
            vc.type = .delegate
        case 1: // closure
            vc.type = .closure
        case 2: // notification
            vc.type = .notification
        case 3: // combine
            vc.type = .combine
            HomeViewController.userInput.sink { (user) in
                self.nameCombineLabel.text = user.name
                self.addressCombineLabel.text = user.address
            }
            .store(in: &subscriptions)
        default:
            break
        }
        vc.delegate = self
        
        vc.closure = { (name, address) in
            self.nameClosureLabel.text = name
            self.addressClosureLabel.text = address
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func updateDataUser(_ notification: NSNotification) {
        guard let name = notification.userInfo?["name"] as? String  else {return}
        guard let address = notification.userInfo?["address"] as? String  else {return}
        nameNotiLabel.text = name
        addressNotiLabel.text = address
    }
    
}

extension HomeViewController: DetailUserViewControllerDelegate {
    func viewController(_ view: DetailUserViewController, needsPerform action: DetailUserViewController.Action) {
        switch action {
        case .done(let name, let address):
            nameDelegateLabel.text = name
            addressDelegateLabel.text = address
        }
    }
    
    
}

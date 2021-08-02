//
//  ViewController.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/29/21.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        binding()
        setupData()
        bindingToViewModel()
    }

    internal func setupUI() { }
    internal func binding() { }
    internal func setupData() { }
    internal func bindingToViewModel() { }

    //MARK: - Publish functions
    func alert(title: String? = "ERROR", text: String?) -> AnyPublisher<Void, Never> {
        let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        return Future { resolve in
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                resolve(.success(()))
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }.handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        }).eraseToAnyPublisher()
    }
}

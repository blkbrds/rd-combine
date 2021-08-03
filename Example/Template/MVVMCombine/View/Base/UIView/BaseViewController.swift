//
//  BaseViewController.swift
//  MVVMCombine
//
//  Created by Tam Nguyen 7 on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import Combine

class BaseViewController: UIViewController {

    // MARK: - Properties
    var subcriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        bindingToView()
        bindingToViewModel()
        router()
    }

    //MARK: - Configuration
    func setupData() { }

    func setupUI() { }

    func bindingToView() { }

    func bindingToViewModel() { }

    //MARK: - Navigation
    func router() { }

    //MARK: - Publish functions
    func alert(title: String, text: String?) -> AnyPublisher<Void, Never> {
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

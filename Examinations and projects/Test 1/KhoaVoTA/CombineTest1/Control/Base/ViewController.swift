//
//  ViewController.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/18/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

// 1. Delegate
protocol ViewControllerDelegate {
    
}

class ViewController: UIViewController {

    // 2. Closure
    var foo: (() -> ())?

    // 4. Combine
    var publisher = PassthroughSubject<Void, Never>()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3. Notification
        NotificationCenter.default.post(name: NSNotification.Name("aaa"), object: nil)
    }
}

//
//  HomeViewController.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/1/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var editDelegate: UIButton!
    @IBOutlet private weak var editClosure: UIButton!
    @IBOutlet private weak var editNotification: UIButton!
    @IBOutlet private weak var editCombine: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
}

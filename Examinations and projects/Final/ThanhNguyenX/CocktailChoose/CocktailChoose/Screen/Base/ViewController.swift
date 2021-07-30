//
//  ViewController.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/22/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
        bindingToView()
        bindingToViewModel()
        bindingAction()
    }

    internal func configData() { }

    internal func configUI() { }

    internal func bindingToView() { }

    internal func bindingToViewModel() { }

    internal func bindingAction() { }
}

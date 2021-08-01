//
//  ViewController.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/31/21.
//

import UIKit
import Combine

protocol ViewControllerType {

    var subscriptions: Set<AnyCancellable> { get }
    var viewModelType: ViewModelType? { get }
}

class ViewController: UIViewController, ViewControllerType {

    var viewModelType: ViewModelType?
    var subscriptions: Set<AnyCancellable> = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
        setupData()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    /*
        This function is used for data setup
        Ex:
        - Call api
        - Fetch data from local database (Realm, SQLite...)
     **/
    internal func setupData() { }

    /*
        This function is used for UI setup
        Ex:
        - Config table view
        - Setup navigation...
     **/
    internal func setupUI() { }

    /*
        This function is used for data binding
     **/
    internal func binding() {
        bindingButtonAction()
        viewModelType?.isLoading
            .dropFirst()
            .sink { [weak self] in
                self?.showHUD($0)
            }
            .store(in: &subscriptions)
    }

    internal func bindingButtonAction() { }

    // MARK: - Objc
    @objc internal func backButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }

    func showHUD(_ force: Bool) {
        if force {
            hud.show()
        } else {
            hud.dismiss()
        }
    }
}

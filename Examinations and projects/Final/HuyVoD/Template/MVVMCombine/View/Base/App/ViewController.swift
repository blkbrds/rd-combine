//
//  ViewController.swift
//  MVVMCombine
//
//  Created by Khoa Vo T.A. VN.Danang on 6/9/21.
//

import UIKit
import Combine
import NVActivityIndicatorView

class ViewController: UIViewController, ViewControllerType {
    var activityIndicator: NVActivityIndicatorView!
    private var indicatorContainerView: UIView!

    var viewModelType: ViewModelType?
    var indicatorTopConstant: CGFloat = 0

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
    internal func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.removeMultiTouch()

        // Config indicator view
        let activityIndicatorX: CGFloat = kScreenSize.width / 2 - Measurement.indicatorContainerSize / 2
        let activityIndicatorY: CGFloat = kScreenSize.height / 2 - Measurement.indicatorContainerSize / 2
        indicatorContainerView = UIView(frame: CGRect(x: activityIndicatorX,
                                                      y: activityIndicatorY - indicatorTopConstant,
                                                      width: Measurement.indicatorContainerSize,
                                                      height: Measurement.indicatorContainerSize))
        indicatorContainerView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 0.8)
        indicatorContainerView.layer.cornerRadius = 12
        activityIndicator = NVActivityIndicatorView(
            frame: CGRect(x: (Measurement.indicatorContainerSize - Measurement.indicatorSize) / 2,
                          y: (Measurement.indicatorContainerSize - Measurement.indicatorSize) / 2,
                          width: Measurement.indicatorSize,
                          height: Measurement.indicatorSize),
            type: .ballSpinFadeLoader,
            color: .darkGray)
        indicatorContainerView.addSubview(activityIndicator)
        view.addSubview(indicatorContainerView)
        indicatorContainerView.isHidden = true
    }

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
        view.isUserInteractionEnabled = !force
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = !force }
        navigationController?.navigationBar.layer.zPosition = force ? -1 : 0
        indicatorContainerView.isHidden = !force
        if force {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

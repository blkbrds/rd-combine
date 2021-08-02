//
//  NavigationController.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 8/2/21.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }

    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        if let topVC = viewControllers.last as? UIViewController {
            // return the status property of each VC, look at step 2
            return topVC.preferredStatusBarStyle
        }
        return statusBarStyle
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let vc = viewControllerToPresent as? UIViewController {
            statusBarStyle = vc.preferredStatusBarStyle
        } else if let vc = viewControllerToPresent as? NavigationController {
            statusBarStyle = vc.preferredStatusBarStyle
        }
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}


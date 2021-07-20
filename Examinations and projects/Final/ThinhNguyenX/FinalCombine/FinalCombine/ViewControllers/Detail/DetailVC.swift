//
//  DetailVC.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import UIKit

class DetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation
    @IBAction private func backButtionTouchUpInSide(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

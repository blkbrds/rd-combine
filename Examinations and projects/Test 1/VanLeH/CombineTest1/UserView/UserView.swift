//
//  UserView.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

protocol UserViewInput {
    func changeEditButtonName()
}

class UserView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }

    func xibSetup() {
        let nib = UINib(nibName: "UserView", bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(containerView)
        containerView.fillToSuperview()
    }

    @IBAction func editButtonTouchUpInside(_ sender: Any) { }
}

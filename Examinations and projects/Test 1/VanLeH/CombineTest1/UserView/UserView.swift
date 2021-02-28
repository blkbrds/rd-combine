//
//  UserView.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

class UserView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    var viewModel: UserViewModel! {
        didSet {
            configUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }

    private func xibSetup() {
        let nib = UINib(nibName: "UserView", bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(containerView)
        containerView.fillToSuperview()
    }

    func configUI() {
        editButton.setTitle(viewModel.editButtonTitle, for: .normal)
    }

    func configUIWithUser(_ user: User) {
        userImageView.image = UIImage(contentsOfFile: user.imageName)
        nameLabel.text = user.name
        addressLabel.text = user.address
    }

    @IBAction func editButtonTouchUpInside(_ sender: Any) { }
}

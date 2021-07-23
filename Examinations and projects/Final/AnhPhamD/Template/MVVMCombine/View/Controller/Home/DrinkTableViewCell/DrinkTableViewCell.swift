//
//  DrinkTableViewCell.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import SDWebImage

class DrinkTableViewCell: TableCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
    }

    var viewModel: DrinkCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func updateUI() {
        guard let viewModel = viewModel else { return }
        print("Da update UI")
        nameLabel.text = viewModel.drinkName
        avatarImageView.sd_setImage(with: URL(string: viewModel.imageURL))
    }

    @IBAction private func favoriteButtonTouchUpInSide(_ sender: Any) {
        print("Favorite")
    }
}

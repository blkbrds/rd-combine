//
//  HomeViewCell.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/14/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit

final class HomeViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var viewModel: HomeCellViewModel? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
    }
}

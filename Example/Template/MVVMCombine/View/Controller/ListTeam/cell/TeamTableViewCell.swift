//
//  TeamTableViewCell.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/16/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import SDWebImage

final class TeamTableViewCell: TableCell {

    // MARK: - IBOulets
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameClubLabel: UILabel!
    @IBOutlet private weak var infomerLabel: UILabel!
    @IBOutlet private weak var nameStadium: UILabel!

    // MARK: - Properties
    var viewModel: TeamCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
        self.layer.cornerRadius = 50
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func updateUI() {
        guard let viewModel = viewModel else { return }
        guard let url = URL(string: viewModel.logo) else { return }
        logoImageView.sd_setImage(with: url, completed: .none)
        nameClubLabel.text = viewModel.nameClub
        nameStadium.text = viewModel.nameStadium
        infomerLabel.text = String(viewModel.intFormedYear)
    }
}

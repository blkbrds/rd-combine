//
//  StoreDetailCell.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import UIKit

final class StoreDetailCell: UITableViewCell {

    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var viewModel: StoreDetailCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        bgImageView.loadImageAsync(with: viewModel.imageString)
        descriptionLabel.text = viewModel.des
    }
}

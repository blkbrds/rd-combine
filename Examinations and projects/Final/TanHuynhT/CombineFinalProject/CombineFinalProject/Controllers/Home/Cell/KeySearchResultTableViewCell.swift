//
//  KeySearchResultTableViewCell.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import UIKit

final class KeySearchResultTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    var viewModel: KeySearchResultCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.keyword
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

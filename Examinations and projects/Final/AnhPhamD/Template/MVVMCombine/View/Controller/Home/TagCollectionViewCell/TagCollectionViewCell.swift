//
//  TagCollectionViewCell.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/23/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class TagCollectionViewCell: CollectionCell {

    @IBOutlet private weak var tagNameLabel: UILabel!
    @IBOutlet private weak var footerView: UIView!

    var viewModel: TagCellViewModel? {
        didSet {
            updateUI()
        }
    }

    var isSelectedCell: Bool? {
        didSet {
            updateSelected()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func updateUI() {
        super.updateUI()
        guard let viewModel = viewModel else { return }
        tagNameLabel.text = viewModel.strCategory
    }

    private func updateSelected() {
        guard let isSelectedCell = isSelectedCell else { return }
        footerView.isHidden = !isSelectedCell
    }
}

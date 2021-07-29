//
//  DesciptionTableViewCell.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/24/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class DesciptionTableViewCell: TableCell {

    @IBOutlet private weak var contentLabel: UILabel!

    var viewModel: DesciptionViewModel? {
        didSet {
            updateUI()
        }
    }

    override func updateUI() {
        guard let viewModel = viewModel else { return }
        contentLabel.text = viewModel.content
    }

}

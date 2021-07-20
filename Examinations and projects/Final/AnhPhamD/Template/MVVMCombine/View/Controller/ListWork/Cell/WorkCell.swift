//
//  WorkCell.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class WorkCell: TableCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var subtitleLabel: Label!

    // MARK: - Properties
    var viewModel: WorkCellViewModel! {
        didSet {
            updateUI()
        }
    }

    // MARK: - Override functions
    override func updateUI() {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

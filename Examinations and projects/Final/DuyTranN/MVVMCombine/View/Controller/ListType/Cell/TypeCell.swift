//
//  TypeCell.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class TypeCell: TableCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: Label!

    // MARK: - Properties
    var viewModel: TypeCellViewModel! {
        didSet {
            updateUI()
        }
    }

    override func updateUI() {
        nameLabel.text = viewModel.title
    }
}

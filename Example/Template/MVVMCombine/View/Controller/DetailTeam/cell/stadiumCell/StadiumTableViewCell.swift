//
//  StadiumTableViewCell.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/24/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import Combine

final class StadiumTableViewCell: TableCell {

    // MARK: - IBOulets
    @IBOutlet private weak var buttonInformation: UIButton!

    // MARK: - Properties
    let checkButton = PassthroughSubject<Bool, Never>()
    enum Action {
        case pressButton
    }

    var viewModel: StadiumViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func updateUI() {
    }

    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        checkButton.send(sender.isTouchInside)
    }
}

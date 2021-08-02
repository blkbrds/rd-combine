//
//  GamePerStoreCell.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import UIKit

final class GamePerStoreCell: UITableViewCell {

    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var idGameLabel: UILabel!

    var viewModel: GamePerStoreCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameTitleLabel.text = viewModel.gameDetail.name
        idGameLabel.text = "\(viewModel.gameDetail.id)"
    }
}

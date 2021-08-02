//
//  CategoryCell.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/29/21.
//

import UIKit
import Combine

final class StoreCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!

    var viewModel: StoreCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.store.name
        domainLabel.text = viewModel.store.domain
        backgroundImageView.loadImageAsync(with: viewModel.store.imgBackground)
    }
}

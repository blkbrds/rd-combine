//
//  HomeTableCell.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/27/21.
//

import UIKit
import Combine

final class HomeTableCell: UITableViewCell {

    @IBOutlet private weak var cellImageView: UIImageView!

    var viewModel: HomeTableCellVM? {
        didSet {
            updateUI()
        }
    }

    private var subscriptions: Set<AnyCancellable> = []

    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateUI() {
        guard let viewModel: HomeTableCellVM = viewModel else { return }
        cellImageView.setImage(viewModel.imageURL)?.store(in: &subscriptions)
        print("AAA", viewModel.imageURL)
//        nameLabel.text = viewModel.name
//        addressLabel.text = viewModel.address
    }
}

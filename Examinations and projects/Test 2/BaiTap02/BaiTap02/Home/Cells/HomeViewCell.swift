//
//  HomeViewCell.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/14/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit
import Combine

final class HomeViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var supermanImageView: UIImageView!

    var subscriptions = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindView(to viewModel: HomeViewModel, indexPath: IndexPath) {
        let cocktail = viewModel.filterPublisher.value
        nameLabel.text = cocktail[indexPath.row].nameTitle
        addressLabel.text = cocktail[indexPath.row].instructions
        supermanImageView.download(from: cocktail[indexPath.row].imageURL)
    }
}

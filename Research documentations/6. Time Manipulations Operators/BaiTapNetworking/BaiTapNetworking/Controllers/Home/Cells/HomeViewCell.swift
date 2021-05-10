//
//  HomeViewCell.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Functions
    func bindView(to viewModel: HomeViewModel, indexPath: IndexPath) {
        let province = viewModel.provinceSubject.value
        nameLabel.text = province[indexPath.row].name
    }
}

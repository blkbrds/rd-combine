//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

final class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func updateView(with viewModel: HomeCellViewModel) {
        let user = viewModel.user
        nameLabel.text = user.name
        addressLabel.text = user.address
    }
}

struct HomeCellViewModel {
    let user: User
}
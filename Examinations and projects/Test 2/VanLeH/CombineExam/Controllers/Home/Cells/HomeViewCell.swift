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

    var viewModel: HomeCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        nameLabel.text = viewModel?.name
        addressLabel.text = viewModel?.address
    }
}

final class HomeCellViewModel {
    var name: String
    var address: String

    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

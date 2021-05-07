//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

final class HomeViewCell: UITableViewCell {

    var viewModel: HomeViewCellModel? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.username
        addressLabel.text = viewModel.address
    }
}

//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var viewModel: HomeViewCellVM? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    private func updateUI() {
        guard let viewModel: HomeViewCellVM = viewModel else { return }
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
    }
}

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

    var viewModel: HomeViewCellModel? {
        didSet {
            nameLabel.text = viewModel?.userName
            addressLabel.text = viewModel?.address
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class HomeViewCell: UITableViewCell {

    var viewModel: HomeCellViewModel! {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateView() {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
    }
}

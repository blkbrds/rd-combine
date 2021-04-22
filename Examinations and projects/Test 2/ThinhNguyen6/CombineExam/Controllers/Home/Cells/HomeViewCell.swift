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
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateView() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.user.name
        addressLabel.text = viewModel.user.address
    }
}

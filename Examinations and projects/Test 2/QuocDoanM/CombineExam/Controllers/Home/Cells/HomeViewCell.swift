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

    var viewModel: HomeViewCellViewModel? {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.cocktail.name
        addressLabel.text = viewModel.cocktail.instructions
    }
}

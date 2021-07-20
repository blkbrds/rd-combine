//
//  LoadmoreTableViewCell.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/19/21.
//

import UIKit

class LoadmoreTableViewCell: UITableViewCell {

    @IBOutlet private weak var loadMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configUI() {
        loadMoreButton.layer.cornerRadius = 20
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.borderColor = UIColor.clear.cgColor
    }
    
}

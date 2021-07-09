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
    
    var user: User? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    private func updateView() {
        nameLabel.text = user?.name
        addressLabel.text = user?.address
    }
}

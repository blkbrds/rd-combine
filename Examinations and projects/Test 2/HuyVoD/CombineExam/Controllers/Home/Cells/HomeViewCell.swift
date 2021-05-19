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
    
    var user: User? {
        didSet {
            nameLabel.text = user?.name
            addressLabel.text = user?.address
        }
    }
    
    var drink: Drink? {
        didSet {
            nameLabel.text = drink?.strGlass
            addressLabel.text = drink?.strTags
        }
    }
}

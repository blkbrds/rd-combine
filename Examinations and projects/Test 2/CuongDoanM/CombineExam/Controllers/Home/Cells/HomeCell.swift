//
//  HomeCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import SDWebImage

final class HomeCell: UITableViewCell {
        
    @IBOutlet private weak var drinkLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    @IBOutlet private weak var modifiedLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!

    func update(drink: Drink) {
        drinkLabel.text = drink.drink
        instructionsLabel.text = drink.instructions
        modifiedLabel.text = drink.modified?.toString(withFormat: .date)
        thumbImageView.sd_setImage(with: URL(string: drink.thumb.orEmpty))
    }
}

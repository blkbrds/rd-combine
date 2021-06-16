//
//  HomeCell.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import UIKit

final class HomeCell: UITableViewCell {

    @IBOutlet private weak var drinkLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    @IBOutlet private weak var modifiedLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!

    func updateUI(_ drink: Drink) {
        drinkLabel.text = drink.drink
        instructionsLabel.text = drink.instructions
        modifiedLabel.text = drink.modified?.toString(withFormat: .date)
        thumbImageView.downloaded(from: drink.thumb ?? "")
    }
}

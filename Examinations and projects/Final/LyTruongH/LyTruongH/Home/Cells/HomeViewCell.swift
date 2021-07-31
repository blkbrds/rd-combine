//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

struct DrinkData {
    let name: String?
    let thumnailImage: String?
    let address: String?
}

final class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var viewModel: HomeCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        guard let url = URL(string: viewModel.thumnailUrl) else { return }
        drinkImage.load(url: url)
        addressLabel.text = viewModel.description
    }
    
    var data: DrinkData? {
        didSet {
            guard let drinkData = data else { return }
            nameLabel.text = drinkData.name
            guard let url = URL(string: drinkData.thumnailImage ?? "") else { return }
            drinkImage.load(url: url)
            addressLabel.text = drinkData.address
        }
    }
}

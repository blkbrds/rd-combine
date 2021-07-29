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
    
    var data: DrinkData? {
        didSet {
            guard let drinkData = data else { return }
            nameLabel.text = drinkData.name
            guard let url = URL(string: drinkData.thumnailImage ?? "") else { return }
            drinkImage.load(url: url)
            addressLabel.text = drinkData.address
        }
    }
    
    var name: String = "" {
        didSet {
//            nameLabel.text = name
        }
    }
    
    var address: String = "" {
        didSet {
            addressLabel.text = address
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

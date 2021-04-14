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

    // ViewModel
    var viewModel: HomeViewCellModel? {
        didSet {
            self.bindingToView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func bindingToView() {

        self.nameLabel.text = viewModel?.user.name
        self.addressLabel.text = viewModel?.user.address
    }
}

final class HomeViewCellModel {
    var user: User

    init(user: User) {
        self.user = user
    }
}

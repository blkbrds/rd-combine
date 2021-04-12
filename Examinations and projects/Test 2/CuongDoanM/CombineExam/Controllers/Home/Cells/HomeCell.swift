//
//  HomeCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class HomeCell: UITableViewCell {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func updateUI(user: User) {
        nameLabel.text = user.name
        addressLabel.text = user.address
    }
}

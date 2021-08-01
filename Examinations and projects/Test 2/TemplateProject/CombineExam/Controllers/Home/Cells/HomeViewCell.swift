//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    private var stores: Set<AnyCancellable> = []

    override func prepareForReuse() {
        super.prepareForReuse()
        stores.removeAll()
    }

    var vm: HomeViewCellVM? {
        didSet {
            guard let vm = vm else { return }
            nameLabel.text = vm.user.name
            addressLabel.text = vm.user.address
            thumbImageView.setImage(vm.user.image ?? "")?.store(in: &stores)
        }
    }
}

struct HomeViewCellVM {
    
    var user: User
}

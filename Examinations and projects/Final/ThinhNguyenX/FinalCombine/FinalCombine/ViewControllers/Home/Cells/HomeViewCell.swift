//
//  HomeViewCell.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import UIKit
import Combine
import SDWebImage

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var showVideoImageView: UIImageView!
    
    private var stores: Set<AnyCancellable> = []

    override func prepareForReuse() {
        super.prepareForReuse()
        stores.removeAll()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var vm: HomeViewCellVM? {
        didSet {
            guard let vm = vm else { return }
            nameLabel.text = vm.cook.name
            if ((vm.cook.thumbnailUrl?.isEmpty) != nil) {
                showVideoImageView.isHidden = false
            } else {
                showVideoImageView.isHidden = true
            }
//            thumbImageView.setImage(vm.cook.thumbnailUrl ?? "")?.store(in: &stores)
            thumbImageView.sd_setImage(with: URL(string: vm.cook.thumbnailUrl ?? ""),
                                       placeholderImage: UIImage(named: "bo_bit_tet.png"))
        }
    }
}

struct HomeViewCellVM {
    var cook: Cook
}

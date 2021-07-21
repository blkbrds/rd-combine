//
//  LoadmoreTableViewCell.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/19/21.
//

import UIKit
import Combine

class LoadmoreTableViewCell: UITableViewCell {

    @IBOutlet private weak var loadMoreButton: UIButton!
    
    var loadmorePublisher: UIControlPublisher<UIButton>?
    var subscriptions = Set<AnyCancellable>()
    var limited: Int = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
        bindingCombine()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configUI() {
        loadMoreButton.layer.cornerRadius = 20
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    func bindingCombine() {
        loadmorePublisher = loadMoreButton.publisher(for: .touchUpInside)
    }
}

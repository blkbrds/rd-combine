//
//  SearchCell.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 8/1/21.
//

import UIKit
import Combine

final class SearchCell: UITableViewCell {

    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var releasedDateLabel: UILabel!
    @IBOutlet private weak var storeLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!

    var downloadPublisher = PassthroughSubject<Void, Never>()
    var viewModel: SearchCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.game.name
        releasedDateLabel.text = "Released: " + (viewModel.game.released ?? "No value")
        if let ratingCount = viewModel.game.rating {
            ratingLabel.text = "Rating: " + "\(ratingCount)"
        } else {
            ratingLabel.text = "Rating: No value"
        }
        if viewModel.game.stores?.count == 0 {
            storeLabel.text = "Store: No value"
        } else {
            storeLabel.text = "Store: " + (viewModel.game.stores?.first?.store?.name ?? "No value")
        }
        bgImageView.loadImageAsync(with: viewModel.game.backgroundImage)
        // Publisher
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//          self.downloadPublisher.send()
//        })
    }
    
}

//
//  VideoInfoTableViewCell.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/27/21.
//

import UIKit

final class VideoInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewCountLabel: UILabel!
    @IBOutlet private weak var publishedLabel: UILabel!

    var viewModel: VideoInfoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.video.title
            viewCountLabel.text = "\(viewModel.video.viewCount) views"
            publishedLabel.text = viewModel.video.publishedAt.toString()
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

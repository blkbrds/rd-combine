//
//  HomeTableViewCell.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/21/21.
//

import UIKit
import SDWebImage
import SwiftUtils

final class VideoTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var chanelTitleLabel: UILabel!

    var viewModel: VideoTableCellModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            thumbnailImageView.setImageWithURL(viewModel.video.thumbnail)
//            iconImageView.setImageWithURL(viewModel.video.i)
            chanelTitleLabel.text = viewModel.video.channelTitle
            titleLabel.text = viewModel.video.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


extension VideoTableViewCell {

    struct Config {
        static var heightOfCell: CGFloat {
            return kScreenSize.width * (3 / 4) + 75
        }
    }
}

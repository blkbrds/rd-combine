//
//  ChannelInfoTableViewCell.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/27/21.
//

import UIKit

final class ChannelInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var numberOfSubscribersLabel: UILabel!
    @IBOutlet private weak var chanelTitleLabel: UILabel!

    var viewModel: ChannelInfoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            thumbnailImageView.setImageWithURL(viewModel.channel.thumbnail)
            chanelTitleLabel.text = viewModel.channel.channelTitle
            numberOfSubscribersLabel.text = "\(viewModel.channel.subcriberCount) views"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.size.width / 2
    }
}

//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit
import Combine

final class HomeViewCell: UITableViewCell {

    var viewModel: HomeCellViewModel! {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateView() {
        nameLabel.text = viewModel.name
        categoryLabel.text = viewModel.category
        thumbnailImageView.dowloadFromServer(link: viewModel.thumbnailURL)
    }
}

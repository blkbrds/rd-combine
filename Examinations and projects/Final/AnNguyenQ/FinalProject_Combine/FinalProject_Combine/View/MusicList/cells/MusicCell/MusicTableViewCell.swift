//
//  MusicTableViewCell.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/19/21.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    // MARK: - Properties
    var viewModel = MusicTableViewCellModel(name: "", artistName: "", urlImage: "") {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func updateUI() {
        musicNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        guard let url = URL(string: viewModel.urlImage) else {
            return
        }
        musicImageView.load(url: url)
    }

}

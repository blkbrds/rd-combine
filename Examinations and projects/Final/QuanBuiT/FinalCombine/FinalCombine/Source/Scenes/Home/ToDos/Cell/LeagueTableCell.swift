//
//  LeagueTableCell.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit
import Kingfisher

class LeagueTableCell: UITableViewCell {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLeagueLabel: UILabel!
    @IBOutlet private weak var formedYearLable: UILabel!
    
    // MARK: - Properties
    var viewModel: LeagueTableCellVM? {
        didSet {
            updateView()
        }
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        nameLeagueLabel.text = viewModel.dataAPI.strLeague
        formedYearLable.text = viewModel.dataAPI.intFormedYear
        logoImageView.setImage(path: viewModel.dataAPI.strLogo ?? "", placeholder: #imageLiteral(resourceName: "img-logo"))
    }
}

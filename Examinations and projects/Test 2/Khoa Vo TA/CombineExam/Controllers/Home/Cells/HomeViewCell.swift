//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

final class HomeViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var cockTailImageView: UIImageView!
    
    // MARK: - Properties
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public
    func bindView(to viewModel: HomeViewModel, indexPath: IndexPath) {
        let cocktail = viewModel.cocktails.value
        nameLabel.text = cocktail[indexPath.row].strDrink
        addressLabel.text = cocktail[indexPath.row].strInstructions
        cockTailImageView.download(from: cocktail[indexPath.row].strDrinkThumb)
    }
}

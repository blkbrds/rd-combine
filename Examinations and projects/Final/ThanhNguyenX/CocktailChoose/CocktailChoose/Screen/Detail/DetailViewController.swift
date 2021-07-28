//
//  DetailViewController.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import UIKit
import Combine

final class DetailViewController: ViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cocktailImageView: UIImageView!

    var viewModel: DetailViewModel = DetailViewModel(cocktail: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
    }

    override func configUI() {
        super.configUI()
        guard let cocktail = viewModel.cocktail else { return }
        cocktailImageView.setImage(cocktail.imageURL)?.store(in: &subscriptions)
        titleLabel.text = cocktail.nameTitle
        descriptionLabel.text = cocktail.instructions
    }
}

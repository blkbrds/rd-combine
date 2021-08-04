//
//  DetailViewController.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 8/3/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

class DetailViewController: ViewController {

    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var glassLabel: UILabel!
    @IBOutlet private weak var alcoholicLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!

    var viewModel: DetailViewModel? {
        didSet {
            getDetailOfDrink()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4352941176, blue: 0.3411764706, alpha: 1)
    }

    override func binding() {
        super.binding()
        guard let viewModel = viewModel else { return }
        viewModel.$apiResult
            .handle(onSucess: { [weak self] in
                self?.categoryLabel.text = $0[0].strCategory
                self?.glassLabel.text = $0[0].strGlass
                self?.alcoholicLabel.text = $0[0].strAlcoholic
                self?.avatarImageView.sd_setImage(with: URL(string: $0[0].imageURL))
            }, onFailure: { [weak self] _ in
                self?.showAlert(error: "Call API Failure")
            })
            .store(in: &subscriptions)
    }

    func getDetailOfDrink() {
        guard let viewModel = viewModel else { return }
        viewModel.getDetailOfDrink()
    }
}

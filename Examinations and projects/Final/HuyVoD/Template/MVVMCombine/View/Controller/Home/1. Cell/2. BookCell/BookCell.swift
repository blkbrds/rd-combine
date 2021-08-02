//
//  BookCell.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class BookCell: TableCell {

    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    var viewModel: BookCellVM! {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookImageView.layer.cornerRadius = 5
        self.layer.cornerRadius = 5
    }
    
    private func updateView() {
        bookImageView.setImage(urlString: viewModel.book.image, placeholderImage: nil)
        titleLabel.text = viewModel.book.title
        priceLabel.text = viewModel.book.price
        subtitleLabel.text = viewModel.book.subtitle
    }
    
}

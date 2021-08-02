//
//  NewBookCell.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

final class NewBookCell: CollectionCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: NewBookCellVM! {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
    }
    
    private func updateView() {
        imageView.setImage(urlString: viewModel.imageURL, placeholderImage: nil)
    }

}

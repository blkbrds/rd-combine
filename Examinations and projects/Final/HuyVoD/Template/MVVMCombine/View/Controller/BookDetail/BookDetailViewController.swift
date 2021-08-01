//
//  BookDetailViewController.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit
import Combine

final class BookDetailViewController: ViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descripsionLabel: UILabel!
    
    var viewModel: BookDetailViewModel!
    
    override var viewModelType: ViewModelType? {
        get {
            return viewModel
        }
        set {
            super.viewModelType = newValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setupData() {
        super.setupData()
        viewModel.performBookDetail()
    }
    
    override func binding() {
        super.binding()
        viewModel.$apiResult
            .handle(onFailure: { [weak self] in
                self?.alert(error: $0)
            })
            .store(in: &subscriptions)
        
        viewModel.book
            .dropFirst()
            .sink { [weak self] in
                guard let this = self else { return }
                this.updateView(with: $0)
            }
            .store(in: &subscriptions)
    }
    
    private func updateView(with book: Book?) {
        guard let book = book else { return }
        imageView.setImage(urlString: book.image, placeholderImage: nil)
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        authorLabel.text = book.author
        publisherLabel.text = book.publisher
        priceLabel.text = book.price
        descripsionLabel.text = book.desc
    }
}

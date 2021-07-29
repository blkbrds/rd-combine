//
//  InformationView.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/24/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

protocol InformationViewDataSource: class {
    func getContent(view: InformationView) -> String
}
final class InformationView: View {

    // MARK: - IBOulets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var contentLabel: UILabel!

    // MARK: - Properties
    weak var dataSource: InformationViewDataSource?
    var viewModel = InfomationViewModel() {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        configContainerView()
        contentLabel.text = self.dataSource?.getContent(view: self)
    }

    private func configContainerView() {

    }
}

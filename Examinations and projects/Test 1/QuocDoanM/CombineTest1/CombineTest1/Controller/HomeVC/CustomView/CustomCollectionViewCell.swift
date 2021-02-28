//
//  CustomCollectionViewCell.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import UIKit

protocol CustomCollectionViewCellDelegate: class {
    func cell(_ cell: CustomCollectionViewCell, needsPerform action: CustomCollectionViewCell.Action)
}

final class CustomCollectionViewCell: UICollectionViewCell {

    enum Action {
        case didSelectedButton
    }

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!

    var viewModel: CustomViewModel? {
        didSet {
            updateUI()
        }
    }

    private var isSetup: Bool = true
    weak var delegate: CustomCollectionViewCellDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        if isSetup {
            configUI()
        }
        isSetup = false
    }

    private func configUI() {
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        editButton.titleLabel?.textAlignment = NSTextAlignment.center
        editButton.layer.cornerRadius = 4
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.user.name
        addressLabel.text = viewModel.user.address
        let title: String = "(" + viewModel.descriptionEdit + ")"
        editButton.setTitle("Edit \n\(title)", for: .normal)
    }

    @IBAction private func editButtonTouchUpInside(_ sender: UIButton) {
        delegate?.cell(self, needsPerform: .didSelectedButton)
    }
}

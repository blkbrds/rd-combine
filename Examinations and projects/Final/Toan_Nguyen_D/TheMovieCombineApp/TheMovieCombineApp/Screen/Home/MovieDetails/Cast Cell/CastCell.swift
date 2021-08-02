//
//  CastCell.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 02/08/2021.
//

import UIKit
import Combine

final class CastCell: UICollectionViewCell {

    @IBOutlet private weak var castNameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!

    var subscriptions = Set<AnyCancellable>()

    var viewModel: CastCellViewModel? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        update()
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        castNameLabel.text = viewModel.castName
        guard let url = URL(string: viewModel.profileURLString ?? "") else { return }
        profileImageView.downloaded(from: url).store(in: &subscriptions)
    }

    private func update() {
        viewModel?.objectWillChange.sink(receiveValue: { [weak self] () in
            print("objectWillChange")
            self?.updateView()
        }).store(in: &subscriptions)
    }

}

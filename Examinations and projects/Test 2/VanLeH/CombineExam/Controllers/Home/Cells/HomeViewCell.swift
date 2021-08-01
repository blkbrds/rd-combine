//
//  HomeViewCell.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import UIKit

final class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!

    var viewModel: HomeCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        nameLabel.text = viewModel?.name
        tagsLabel.text = viewModel?.tags
    }
}

final class HomeCellViewModel {
    var name: String
    var tags: String?

    init(name: String, tags: String?) {
        self.name = name
        self.tags = tags
    }
}

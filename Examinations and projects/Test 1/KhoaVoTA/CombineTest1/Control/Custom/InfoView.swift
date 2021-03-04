//
//  InfoView.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 2/28/21.
//

import UIKit
import Combine

// 1. Delegate
protocol InfoViewDelegate: class {
    func view(_ view: InfoView, needsPerform action: InfoView.Action)
}

final class InfoView: View {

    // 1. Delegate
    enum Action {
        case moveToEdit
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var editInfoButton: UIButton!

    // MARK: - Properties
    var viewModel: InfoViewModel? {
        didSet {
            updateView()
        }
    }

    // 1. Delegate
    weak var delegate: InfoViewDelegate?

    // 2. Closure
    var moveToEditCompletion: (() -> Void)?

    // 3. Notification

    // 4. Combine
    var subject: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        editInfoButton.titleLabel?.textAlignment = .center
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        editInfoButton.setTitle(viewModel.viewType.title, for: .normal)
        if let info = viewModel.info {
            if !info.name.isEmpty {
                nameLabel.text = info.name
            }
            if !info.address.isEmpty {
                addressLabel.text = info.address
            }
        }
    }

    

    // MARK: - IBActions
    @IBAction private func editInfoButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        switch viewModel.viewType {
        case .delegate:
            delegate?.view(self, needsPerform: .moveToEdit)
        case .closure:
            moveToEditCompletion?()
        case .notification:
            NotificationCenter.default.post(name: .moveToEdit, object: nil)
        case .combine:
            subject.send(.moveToEdit)
        }
    }
}

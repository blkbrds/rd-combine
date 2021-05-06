//
//  InfoView.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/26/21.
//

import UIKit
import Combine

// [1][Edit] - Delegate - Create delegate
protocol InfoViewDelegate: class {
    func view(_ view: InfoView, needsPerform action: Action<Person>)
}

final class InfoView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    private var subscriptions: Set<AnyCancellable> = []
    var pattern: Pattern? {
        didSet {
            updateEditButton()
        }
    }
    // [1][Edit] - Delegate: Create instance
    weak var delegate: InfoViewDelegate?
    // [2][Edit] - Closure - Declare closure
    var editHandler: (() -> Void)?
    // [4][Edit] - Combine - Define publisher
    let editPublisher: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("InfoView", owner: self)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.layer.cornerRadius = 5.0
        editButton.titleLabel?.textAlignment = .center
    }
    
    private func updateEditButton() {
        guard let pattern: Pattern = pattern else {
            return
        }
        editButton.setTitle("Edit\n(\(pattern.name))", for: .normal)
    }
    
    func bind(to person: Person) {
        person.$name.assign(to: \.text!, on: nameLabel).store(in: &subscriptions)
        person.$address.assign(to: \.text!, on: addressLabel).store(in: &subscriptions)
    }
    
    @IBAction private func editButtonTouchUpInside(_ sender: UIButton) {
        guard let pattern: Pattern = pattern else {
            return
        }
        switch pattern {
        case .delegate:
            // [1][Edit] - Delegate - Call delegate
            delegate?.view(self, needsPerform: .edit)
        case .closure:
            // [2][Edit] - Closure - Call closure
            editHandler?()
        case .notification:
            // [3][Edit] - Notification - Post notification
            NotificationCenter.default.post(Notification(name: .EditInformation))
        case .combine:
            // [4][Edit] - Combine - Emit value
            editPublisher.send()
        }
    }
}

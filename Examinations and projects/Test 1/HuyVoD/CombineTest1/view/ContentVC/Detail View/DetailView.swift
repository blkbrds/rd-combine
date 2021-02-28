//
//  DetailView.swift
//  CombineTest1
//
//  Created by MBA0288F on 2/26/21.
//

import UIKit
import Combine

enum ViewType {
    case delegate
    case closure
    case notification
    case combine
    
    var buttonTitle: String {
        switch self {
        case .delegate:
            return "Edit\n(Delegate)"
        case .closure:
            return "Edit\n(Closure)"
        case .notification:
            return "Edit\n(Notification)"
        case .combine:
            return "Edit\n(Combine)"
        }
    }
}
// 1. Delegate
protocol DetailViewDelegate: class {
    func view(_view: DetailView, needPerforms action: DetailView.Action)
}

final class DetailView: UIView {
    
    enum Action {
        case moveEdit
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var moveEditScreenButton: UIButton!
    
    var viewModel: DetailViewVM! {
        didSet {
            updateView()
        }
    }
    
    // 1. Delegate
    weak var delegate: DetailViewDelegate?
    
    // 2. Closure
    var moveEdit: (() -> Void)?
    
    // 4. Combine
    var actionSubject: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let nibName = String(describing: DetailView.self)
        Bundle.main.loadNibNamed(nibName, owner: self)
        moveEditScreenButton.titleLabel?.textAlignment = .center
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        guard let contentView = contentView else { return }
        addConstraint(NSLayoutConstraint(item: contentView,
                                         attribute: .top,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView,
                                         attribute: .bottom,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView,
                                         attribute: .leading,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView,
                                         attribute: .trailing,
                                         relatedBy: .equal, toItem: self,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0))
    }
    
    private func updateView() {
        guard let vm = viewModel else { return }
        nameLabel.text = vm.name
        addressLabel.text = vm.address
        moveEditScreenButton.setTitle(vm.type.buttonTitle, for: .normal)
    }

    @IBAction func moveEditScreenButtonTouchUpInside(_ sender: UIButton) {
        switch viewModel.type {
        case .delegate:
            // 1. Delegate
            delegate?.view(_view: self, needPerforms: .moveEdit)
        case .closure:
            // 2. Closure
            moveEdit?()
        case .notification:
            // 3. Notification
            NotificationCenter.default.post(name: .moveEdit, object: nil)
        case .combine:
            // 4. Combine
            actionSubject.send(.moveEdit)
        }
    }
    
}

final class DetailViewVM {
    var name: String
    var address: String
    var type: ViewType
    
    init(user: UserInfomation, type: ViewType) {
        self.name = user.name
        self.address = user.address
        self.type = type
    }
}

struct UserInfomation {
    var name: String
    var address: String
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

//
//  View.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 2/28/21.
//

import UIKit

class View: UIView {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    private func loadNib() {
        let bundle = Bundle.main
        var xib: String?
        let name = String(describing: type(of: self))

        if bundle.hasNib(name: name) {
            xib = name
        }

        if let xib = xib, let view = bundle.loadNibNamed(xib, owner: self)?.first as? UIView {
            addSubview(view)
            view.anchorToSuperView()
        }
    }
}

extension Bundle {
    func hasNib(name: String) -> Bool {
        return path(forResource: name, ofType: "nib") != nil
    }
}

extension UIView {

    struct AnchorOptions: OptionSet {

        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let top = UIView.AnchorOptions(rawValue: 1 << 0)

        static let leading = UIView.AnchorOptions(rawValue: 1 << 1)

        static let trailing = UIView.AnchorOptions(rawValue: 1 << 2)

        static let bottom = UIView.AnchorOptions(rawValue: 1 << 3)

        static let all: UIView.AnchorOptions = [.top, .leading, .trailing, .bottom]
    }

    func anchor(toView view: UIView?, insets: UIEdgeInsets = .zero, anchorOptions options: AnchorOptions = .all) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false

        if options.contains(.top) {
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        }
        if options.contains(.leading) {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        }
        if options.contains(.trailing) {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        }
        if options.contains(.bottom) {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }

    func anchorToSuperView(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        anchor(toView: superview, insets: insets)
    }

    class func loadNib<T: UIView>() -> T {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named `\(name)`")
        }
        return xib
    }
}

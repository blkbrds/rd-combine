//
//  BaseView.swift
//  Test1Combine
//
//  Created by Duy Tran N. on 2/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit.UIView

class BaseView: UIView {

    deinit {
        gestureRecognizers?.forEach(removeGestureRecognizer)
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
            afterLoadNib()
        }
    }

    func afterLoadNib() {

    }
}

extension Bundle {
    func hasNib(name: String) -> Bool {
        return path(forResource: name, ofType: "nib") != nil
    }
}

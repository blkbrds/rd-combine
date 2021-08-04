//
//  View.swift
//  MVVMCombine
//
//  Created by MBA0242P on 4/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

class View: UIView {

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

//
//  TableViewExt.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/29/21.
//

import UIKit

extension UITableView {

    public func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }

    public func dequeue<T: UITableViewCell>(cell aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }
        return cell
    }
}

extension UITableView {
    func removeExtraCells() {
        tableFooterView = UIView(frame: .zero)
    }
}

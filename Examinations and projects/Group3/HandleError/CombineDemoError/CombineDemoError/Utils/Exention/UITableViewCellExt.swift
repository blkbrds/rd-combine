//
//  UITableViewCellExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import UIKit

extension UITableViewCell {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        return "\(self)"
    }

    static func registerCellXib(with tableview: UITableView){
        let nib = UINib(nibName: self.storyboardID, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: self.storyboardID)
    }
}

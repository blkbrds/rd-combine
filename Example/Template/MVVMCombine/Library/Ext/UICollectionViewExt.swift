//
//  UICollectionViewExt.swift
//  MVVMCombine
//
//  Created by Van Le H. on 5/26/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionReusableView>(header aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionHeader
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func dequeue<T: UICollectionReusableView>(header aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func register<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }

    func dequeue<T: UICollectionViewCell>(cell aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}

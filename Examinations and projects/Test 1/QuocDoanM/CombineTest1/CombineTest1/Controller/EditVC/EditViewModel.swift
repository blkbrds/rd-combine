//
//  EditViewModel.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import Foundation

final class EditViewModel {

    var indexPath: IndexPath?
    var user: User = User()

    init(indexPath: IndexPath?) {
        self.indexPath = indexPath
    }
}

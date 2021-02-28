//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import Foundation

final class HomeViewModel {

    var indexPath: IndexPath?
    var user: User = User()

    func numberOfItems(in section: Int) -> Int {
        return PassDataType.allCases.count
    }

    func cellForItem(at indexPath: IndexPath) -> CustomViewModel {
        guard let type: PassDataType = PassDataType(rawValue: indexPath.row) else {
            return CustomViewModel(user: user,
                                   descriptionEdit: "")
        }
        return CustomViewModel(user: user,
                               descriptionEdit: type.title)
    }

    func getEditViewModel() -> EditViewModel {
        return EditViewModel(indexPath: indexPath)
    }
}

//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by Quoc Doan M. on 2/28/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    var indexPath: IndexPath?
    var users: [User] = [User(), User(), User(), User()]

    func numberOfItems(in section: Int) -> Int {
        return PassDataType.allCases.count
    }

    func cellForItem(at indexPath: IndexPath) -> CustomViewModel {
        guard let type: PassDataType = PassDataType(rawValue: indexPath.row) else {
            return CustomViewModel(user: users[indexPath.row],
                                   descriptionEdit: "")
        }
        return CustomViewModel(user: users[indexPath.row],
                               descriptionEdit: type.title)
    }

    func getEditViewModel() -> EditViewModel {
        return EditViewModel(indexPath: indexPath)
    }
}

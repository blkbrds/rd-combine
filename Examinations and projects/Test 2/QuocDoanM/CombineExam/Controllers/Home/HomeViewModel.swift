//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var users: [User] = LocalDatabase.users
    var searchList: [User] = []
    var keyword: String = ""

    func numberOfItem() -> Int {
        return keyword.isEmpty ? users.count : searchList.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> HomeViewCellViewModel {
        return keyword.isEmpty ? HomeViewCellViewModel(user: users[indexPath.row]) : HomeViewCellViewModel(user: searchList[indexPath.row])
    }
}

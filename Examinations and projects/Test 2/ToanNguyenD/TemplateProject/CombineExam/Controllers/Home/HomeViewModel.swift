//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
final class HomeViewModel {

    var userList: [User] = LocalDatabase.users
    var userSearchList: [User] = []
    var searchtext: String = ""

    func numberOfItem() -> Int {
        return searchtext.isEmpty ? userList.count: userSearchList.count
    }

    func itemOfCell(in indexPath: IndexPath) -> HomeCellViewModel {
        let user: User = searchtext.isEmpty ? userList[indexPath.row] : userSearchList[indexPath.row]
        let vm = HomeCellViewModel(user: user)
        return vm
    }
}

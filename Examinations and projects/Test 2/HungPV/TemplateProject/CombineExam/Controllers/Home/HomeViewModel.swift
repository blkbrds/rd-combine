//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    let users = LocalDatabase.users
    var filterUsers = LocalDatabase.users

    init() { }

    func getUser(with indexPath: IndexPath) -> User {
        return filterUsers[indexPath.row]
    }
}

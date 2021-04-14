//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    let users: [User] = LocalDatabase.users
    var filteredUser: [User] = LocalDatabase.users

    func numberOfItems(inSection section: Int) -> Int {
        return self.filteredUser.count
    }
}

//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation

final class HomeViewModel {

    var users: [User] = LocalDatabase.users

    func viewModelForCell(at indexPath: IndexPath) -> HomeCellViewModel? {
        guard indexPath.row < users.count else { return nil }
        let user = users[indexPath.row]
        let vm = HomeCellViewModel(name: user.name, address: user.address)
        return vm
    }
}

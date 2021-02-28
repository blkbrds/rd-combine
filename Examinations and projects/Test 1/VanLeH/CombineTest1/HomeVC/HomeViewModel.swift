//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation

enum AsynchronousWay: Int {
    case delegate
    case closure
    case notification
    case combine

    var editButtonTitle: String {
        switch self {
        case .delegate:
            return "Edit\n(Delegate)"
        case .closure:
            return "Edit\n(Closure)"
        case .notification:
            return "Edit\n(Notification)"
        case .combine:
            return "Edit\n(Combine)"
        }
    }
}

final class HomeViewModel {

    var users: [User] = []

    init() {
        users = DummyData.fetchUsers()
    }

    func viewModelForUserView(wayIndex: Int) -> UserViewModel? {
        guard let way = AsynchronousWay(rawValue: wayIndex) else { return nil }
        let viewModel = UserViewModel(editButtonTitle: way.editButtonTitle, user: users[wayIndex])
        return viewModel
    }

    func viewModelForEditVC(wayIndex: Int) -> EditViewModel? {
        guard let way = AsynchronousWay(rawValue: wayIndex) else { return nil }
        switch way {
        case .delegate, .closure, .notification:
            let viewModel = EditViewModelNormalWay(tag: wayIndex, user: users[wayIndex])
            return viewModel
        case .combine:
            let viewModel = EditViewModelCombineWay(tag: wayIndex, user: users[wayIndex])
            return viewModel
        }
    }
}

struct DummyData {
    static func fetchUsers() -> [User] {
        var users: [User] = []
        for i in 0...3 {
            users.append(User(imageName: "ic-user", name: "Van Le \(i)", address: "Da Nang, Viet Nam"))
        }
        return users
    }
}

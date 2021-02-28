//
//  HomeViewModel.swift
//  QueDinhT
//
//  Created by MBA0023 on 2/28/21.
//

import Foundation

final class HomeViewModel {
    var users: [User] = [User(name: "Luffy", address: "Ha Noi"),
                         User(name: "Zoro", address: "Da Nang"),
                         User(name: "Sanji", address: "Quy Nhon"),
                         User(name: "Nami", address: "Sai Gon")]
//    var user2 = User(name: "Zoro", address: "Da Nang")
//    var user3 = User(name: "Sanji", address: "Quy Nhon")
//    var user4 = User(name: "Nami", address: "Sai Gon")

    func viewModelForEdit(editType: EditType) -> EditViewModel {
        return EditViewModel(editType: editType, user: users[editType.rawValue])
    }
}

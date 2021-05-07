//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var users: [User] = []
    var subscription = Set<AnyCancellable>()

    func searchBy(keyword: String) {
        let keyword = keyword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if keyword.isEmpty {
            users = LocalDatabase.users
        } else {
            users = LocalDatabase.users.filter({$0.name.lowercased().contains(keyword)})
        }
    }
}

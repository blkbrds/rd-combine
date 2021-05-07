//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import UIKit
import Combine

final class HomeViewModel {

    var users: [User] = LocalDatabase.users
    var subscriptions = Set<AnyCancellable>()
    var searchInput  = PassthroughSubject<String, Never>()
    init() {
        searchInput
            .sink{ value in
                guard !value.isEmpty else {
                    self.users = LocalDatabase.users
                    return
                }
                self.users = LocalDatabase.users.filter({ $0.name.contains(value) })
            }
            .store(in: &subscriptions)
    }

    // MARK: - Public functions
    func numberOfRows() -> Int {
        return users.count
    }

    func viewModelForHomeViewCell(at indexPath: IndexPath) -> HomeCellViewModel {
        let user = users[indexPath.row]
        return HomeCellViewModel(user: user)
    }
}


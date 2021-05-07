//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    // MARK: - Properties
    var displayUsers: [User] = LocalDatabase.users
    var searchInputSubject = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    init() {
        searchInputSubject
            .sink(receiveValue: { [weak self] value in
                guard let this = self else { return }
                guard !value.isEmpty else {
                    this.displayUsers = LocalDatabase.users
                    return
                }
                this.displayUsers = LocalDatabase.users.filter({ $0.name.contains(value) })
            })
            .store(in: &subscriptions)
    }

    // MARK: - Public functions
    func numberOfRows() -> Int {
        return displayUsers.count
    }

    func viewModelForHomeViewCell(at indexPath: IndexPath) -> HomeCellViewModel {
        let user = displayUsers[indexPath.row]
        return HomeCellViewModel(user: user)
    }
}

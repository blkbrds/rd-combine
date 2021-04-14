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
    let sourcesUsers = LocalDatabase.users
    var displayUsers: [User] = []
    var searchInputSubject = CurrentValueSubject<String, Never>("")
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Life cycle
    init() {
        searchInputSubject
            .sink(receiveValue: { [weak self] _ in
                guard let this = self else { return }
                guard !this.searchInputSubject.value.isEmpty else {
                    this.displayUsers = this.sourcesUsers
                    return
                }
                this.displayUsers = this.sourcesUsers.filter({ $0.name.contains(this.searchInputSubject.value) })
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

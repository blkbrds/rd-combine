//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var users: [User] = LocalDatabase.users
    var inputtedTextSubject: PassthroughSubject = PassthroughSubject<String?, Never>()
    var didSearch: PassthroughSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = [AnyCancellable]()

    init() {
        inputtedTextSubject
            .replaceNil(with: "")
            .sink { [weak self] in
                self?.querySearch(text: $0)
            }
            .store(in: &subscriptions)
    }

    func viewModelForCell(at indexPath: IndexPath) -> HomeCellViewModel? {
        guard indexPath.row < users.count else { return nil }
        let user = users[indexPath.row]
        let vm = HomeCellViewModel(name: user.name, address: user.address)
        return vm
    }

    private func querySearch(text: String) {
        guard !text.isEmpty else {
            users = LocalDatabase.users
            didSearch.send(())
            return
        }
        var results: [User] = []
        for user in LocalDatabase.users {
            if user.name.lowercased().contains(text) {
                results.append(user)
            }
        }
        users = results
        didSearch.send(())
    }
}

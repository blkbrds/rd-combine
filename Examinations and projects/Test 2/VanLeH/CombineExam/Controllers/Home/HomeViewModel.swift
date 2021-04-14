//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var users: CurrentValueSubject<[User], Never> = .init([])
    var inputtedTextSubject: PassthroughSubject = PassthroughSubject<String?, Never>()
    var didSearch: PassthroughSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = [AnyCancellable]()

    init() {
        users.send(LocalDatabase.users)

        inputtedTextSubject
            .replaceNil(with: "")
            .map { keyword in
                guard !keyword.isEmpty else {
                    return LocalDatabase.users
                }
                return LocalDatabase.users.filter { $0.name.lowercased().contains(keyword) }
            }
            .assign(to: \.users.value, on: self)
            .store(in: &subscriptions)
    }

    func viewModelForCell(at indexPath: IndexPath) -> HomeCellViewModel? {
        guard indexPath.row < users.value.count else { return nil }
        let user = users.value[indexPath.row]
        let vm = HomeCellViewModel(name: user.name, address: user.address)
        return vm
    }
}

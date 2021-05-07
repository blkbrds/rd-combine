//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var user = CurrentValueSubject<[User],Never>(LocalDatabase.users)
    var subscriptions = Set<AnyCancellable>()
    
    @Published var keyword: String = ""

    init() {
        $keyword
            .map({ $0.lowercased().trimmingCharacters(in: .whitespaces)})
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map({ keyword -> [User] in
                if keyword.isEmpty {
                    return LocalDatabase.users
                } else {
                    return LocalDatabase.users.filter { $0.name.lowercased().hasPrefix(keyword) }
                }
            })
            .sink(receiveValue: { users in
                self.user.send(users)
            }).store(in: &subscriptions)
    }

    func numberOfRowInSection() -> Int {
        return user.value.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> HomeCellViewModel {
        let users = user.value[indexPath.row]
        return HomeCellViewModel(user: users)
    }
}

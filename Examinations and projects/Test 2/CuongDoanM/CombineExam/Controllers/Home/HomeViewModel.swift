//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Combine
import UIKit

final class HomeViewModel {
    
    private var subscriptions: Set<AnyCancellable> = []
    let searchResult: CurrentValueSubject<[User], Never> = .init(LocalDatabase.users)
    let keyword: PassthroughSubject<String, Never> = .init()
    
    init() {
        keyword
            .map { keyword in
                if keyword.isEmpty { return LocalDatabase.users }
                return LocalDatabase.users.filter { $0.name.lowercased().contains(keyword.lowercased()) }
            }
            .subscribe(searchResult)
            .store(in: &subscriptions)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return searchResult.value.count
    }
    
    func getUser(at indexPath: IndexPath) -> User? {
        guard let user: User = searchResult.value[safe: indexPath.row] else { return nil }
        return user
    }
}

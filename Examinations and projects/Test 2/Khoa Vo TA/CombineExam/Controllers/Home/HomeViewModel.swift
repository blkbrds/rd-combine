//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    
    private(set) var users: CurrentValueSubject = CurrentValueSubject<[User], Never>([])
    
    @Published var keyword: String?
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        $keyword.map({ keyword -> [User] in
            guard let keyword = keyword else { return [] }
            return LocalDatabase.users.filter { $0.name.lowercased().contains(keyword.lowercased()) }
        }).sink(receiveValue: { [weak self] users in
            guard let this = self else { return }
            this.users.send(users)
        }).store(in: &subscriptions)
    }

    func numberOfItems() -> Int {
        return users.value.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> HomeViewCellViewModel {
        let item = users.value[indexPath.row]
        return HomeViewCellViewModel(name: item.name, address: item.address)
    }
}

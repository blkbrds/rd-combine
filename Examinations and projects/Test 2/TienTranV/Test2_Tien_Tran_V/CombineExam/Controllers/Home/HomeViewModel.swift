//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    var subscription: Set<AnyCancellable> = []
    @Published private (set) var users: [User] = []
    @Published var searchText: String = String()
    let userDB = LocalDatabase.users
    let searchResult = PassthroughSubject<(), Error>()

    init() {
        users = userDB
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.users = []
                    return nil
                }
                return string
            })
            .compactMap{ $0 }
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [self] (searchField) in
                searchItems(searchText: searchField)
            })
            .store(in: &subscription)
    }

    private func searchItems(searchText: String) {
        let tmp: [User] = userDB.filter { $0.name == searchText }
        users = tmp
        searchResult.send()
    }
}

extension HomeViewModel {
    func getHomeCellViewModel(atIndexPath indexPath: IndexPath) -> HomeCellViewModel? {
        guard indexPath.row < users.count else {
            return nil
        }
        let user = users[indexPath.row]
        return HomeCellViewModel(user: user)
    }
}

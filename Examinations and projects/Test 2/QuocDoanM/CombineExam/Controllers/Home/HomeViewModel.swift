//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    @Published var searchList: [User] = []
    @Published var keyword: String = ""

    var users: [User] = LocalDatabase.users
    var resultPublisher: AnyCancellable?
    private var stores = Set<AnyCancellable>()

    init() {
        resultPublisher = $keyword
            .receive(on: RunLoop.main)
            .sink(receiveValue: { keyword in
                if !keyword.isEmpty {
                    self.searchList = self.users.filter { $0.name.lowercased().contains(keyword.lowercased()) }
                } else {
                    self.searchList = self.users
                }
            })
    }

    func numberOfItem() -> Int {
        return searchList.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> HomeViewCellViewModel {
        return HomeViewCellViewModel(user: searchList[indexPath.row])
    }
}

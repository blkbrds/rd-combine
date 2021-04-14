//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    // MARK: - Define
    // State
    enum State {
        case initial
        case fetched
        case error(message: String)
        case reloadCell(indexPath: IndexPath)
    }

    @Published var keyWord: String?
    @Published var users: [User] = LocalDatabase.users

    // State
    let state = CurrentValueSubject<State, Never>(.initial)

    func numberOfRows(in section: Int) -> Int {
        users.count
    }

    func userCellViewModel(at indexPath: IndexPath) -> HomeViewCellModel {
        HomeViewCellModel(user: users[indexPath.row])
    }
}

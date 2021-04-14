//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {

    var usernameText: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")

    init() {
    }

    func getUser(with indexPath: IndexPath) -> User {
        return LocalDatabase.users[indexPath.row]
    }
}

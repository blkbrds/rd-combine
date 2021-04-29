//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    var users = CurrentValueSubject<[User], Never>(LocalDatabase.users)
    @Published var searchText: String?
    var subscriptions: Set<AnyCancellable> = []
    
    init() {
        $searchText
            .dropFirst()
            .sink { value in
                let usersSearch = LocalDatabase.users.filter {
                    $0.name.lowercased().contains(value?.lowercased() ?? "")
                  }
                self.users.send(usersSearch)
            }
            .store(in: &subscriptions)
    }
}


//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    @Published var searchKeyword: String = ""
    @Published var users: [User] = []
    
    var stores: Set<AnyCancellable> = []
    private var usersOriginal: [User] = []
    
    init() {
        usersOriginal = LocalDatabase.users
        
        $searchKeyword.map { text -> [User] in
            if text.isEmpty {
                return self.usersOriginal
            }
            return self.usersOriginal.filter { $0.name.contains(text) }
        }
        .assign(to: \.users, on: self)
        .store(in: &stores)
    }
}

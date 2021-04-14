//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    
    let searchKey: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    let listUser: CurrentValueSubject<[User], Never> = CurrentValueSubject<[User], Never>(LocalDatabase.users)
    
    var subscription = Set<AnyCancellable>()
    
    init() {
        searchKey.sink { [weak self] (key) in
            guard let this = self else { return }
            if key.isEmpty {
                this.listUser.send(LocalDatabase.users)
            } else {
                this.listUser.send(LocalDatabase.users.filter { $0.name.contains(key) })
            }
            }.store(in: &subscription)
    }
    
}

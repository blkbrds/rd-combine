//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by PCI0015 on 3/2/21.
//

import Foundation

class HomeViewModel {
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func viewModelForEdit() -> EditViewModel? {
        let editViewModel = EditViewModel(user: user)
        return editViewModel
    }
}

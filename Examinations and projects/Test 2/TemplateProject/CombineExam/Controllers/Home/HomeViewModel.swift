//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import UIKit
import Combine

final class HomeViewModel {
    
    enum Action {
        case name
        case address
    }
    
    var name = PassthroughSubject<User, Never>()
    var address = PassthroughSubject<User, Never>()
    
}

extension HomeViewModel {
    
}

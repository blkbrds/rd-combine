//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    
    // var data: [User] = []
    
    var data: AnyPublisher<[User], Never>?
    
    @Published var keyword: String = ""
    
    private func handleSearchResult() {
        //data = 
    }
}

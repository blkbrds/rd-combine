//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class HomeViewModel {
    var users = LocalDatabase.users
    var searchResults: [User] = []
    
    var numberOfRows: Int {
        return searchResults.count
    }
    
    func userForCell(at indexPath: IndexPath) -> User? {
        guard indexPath.row < searchResults.count else {
            return nil
        }
        return searchResults[indexPath.row]
    }
    
    func searchUsers(with text: String) {
        searchResults = users.filter({ $0.name.lowercased().hasPrefix(text.lowercased()) })
    }
}

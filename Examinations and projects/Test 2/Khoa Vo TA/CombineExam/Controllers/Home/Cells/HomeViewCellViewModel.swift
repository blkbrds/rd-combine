//
//  HomeViewCellViewModel.swift
//  CombineExam
//
//  Created by MBA0242P on 4/14/21.
//

import Foundation

final class HomeViewCellViewModel {
    
    // MARK: - Properties
    private(set) var name: String = ""
    private(set) var address: String = ""
    
    init(name: String = "", address: String = "") {
        self.name = name
        self.address = address
    }
}

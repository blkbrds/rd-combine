//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by NganHa on 28/02/2021.
//

import Foundation

final class HomeViewModel {

    private(set) var name: String = "Robert Pattinson"
    private(set) var address: String = "London, England"

    func updateInformation(_ newName: String, _ newAddress: String) {
        name = newName
        address = newAddress
    }
}

//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by Thanh Nguyen X. on 02/26/21.
//

import Foundation

final class HomeViewModel {

    var editType: EditType = .delegate
    var editShowData: Human?

    var humanDelegate: Human = Human(name: "Songoku", address: "Japan")
    var humanClosure: Human = Human(name: "Songoku", address: "China")
    var humanNotification: Human = Human(name: "Songoku", address: "United States")
}

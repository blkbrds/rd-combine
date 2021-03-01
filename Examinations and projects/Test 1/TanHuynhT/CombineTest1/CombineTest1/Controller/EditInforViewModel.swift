//
//  EditInforViewModel.swift
//  CombineTest1
//
//  Created by TanHuynh on 2021/02/28.
//

class EditInforViewModel {

    var name: String
    var address: String
    var type: HomeViewController.TranferType = .delegate

    init(name: String = "", address: String = "", type: HomeViewController.TranferType) {
        self.name = name
        self.address = address
        self.type = type
    }
}

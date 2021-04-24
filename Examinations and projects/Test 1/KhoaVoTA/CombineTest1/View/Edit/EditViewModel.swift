//
//  EditViewModel.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 3/2/21.
//

import Foundation

final class EditViewModel {

    private(set) var fromViewType: InfoViewType
    private(set) var info: Info?

    init(info: Info?, fromViewType: InfoViewType) {
        self.info = info
        self.fromViewType = fromViewType
    }

    func createInfoObject(name: String?, address: String?) -> Info {
        let name: String = name ?? ""
        let address: String = address ?? ""
        let info = Info(name: name, address: address)
        return info
    }
}

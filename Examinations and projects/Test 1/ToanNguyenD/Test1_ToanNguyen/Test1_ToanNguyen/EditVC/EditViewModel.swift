//
//  EditViewModel.swift
//  Test1_ToanNguyen
//
//  Created by Toan Nguyen D. [4] on 2/28/21.
//

import Foundation

final class EditViewModel {

    enum PassDataType {
        case delegate
        case closure
        case notification
        case combine
    }

    var passDataType: PassDataType
    var user: UserInformation

    init(passDataType: PassDataType = .delegate, user: UserInformation = UserInformation()) {
        self.passDataType = passDataType
        self.user = user
    }
}

//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by Toan Nguyen D. [4] on 4/14/21.
//

import Foundation
import Combine

final class HomeCellViewModel {

    var name: String = ""
    var address: String = ""
    private let user: User

    init(user: User) {
        self.user = user
        inforBinding()
    }

    private func inforBinding() {
        name = user.name
        address = user.address
    }
}

//
//  HomeViewModel.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/14/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Combine
import Foundation

final class HomeViewModel {
    var filterPublisher = CurrentValueSubject<[User],Never>(LocalDatabase.users)
    var resultList: [User] = []

    init(resultList: [User]) {
        self.resultList = resultList
    }

    func viewModelForCell(indexPath: IndexPath) -> HomeCellViewModel? {
        let name: String = resultList[indexPath.row].name
        let address: String = resultList[indexPath.row].address
        return HomeCellViewModel(name: name, address: address)
    }
}

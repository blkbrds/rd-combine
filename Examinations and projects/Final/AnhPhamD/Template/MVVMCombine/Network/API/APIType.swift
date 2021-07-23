//
//  APIType.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class APIType {
    static func getListType() -> AnyPublisher<TypeList, Error> {
        return NetworkingController.shared
            .requestWithTarget(TypeService.listType)
            .response(TypeList.self)
            .eraseToAnyPublisher()
    }

    static func getListWork(typeId: String, currentPage: Int) -> AnyPublisher<WorkList, Error> {
        return NetworkingController.shared
            .requestWithTarget(TypeService.listWork(typeId: typeId, offset: currentPage))
            .response(WorkList.self)
            .eraseToAnyPublisher()
    }

    static func getDrinkByCategory(key: String, strCategory: String) -> AnyPublisher<[Drink], Error> {
        return NetworkingController.shared
            .requestWithTarget(TypeService.getCategory(key: key, strCategory: strCategory))
            .response([Drink].self)
            .eraseToAnyPublisher()
    }
}

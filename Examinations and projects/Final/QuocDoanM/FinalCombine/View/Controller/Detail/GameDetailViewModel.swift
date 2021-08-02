//
//  GameDetailViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/31/21.
//

import Foundation
import Combine

final class GameDetailViewModel {

    var id: Int
    var gameName: String

    init(id: Int, gameName: String) {
        self.id = id
        self.gameName = gameName
    }

    @Published var gamePerstoreDetail: GameDetailResponse = GameDetailResponse()
    var stores = [AnyCancellable]()

    func getGamePerStoreDetail() {
        API.Search.requestGameDetail(id: id)
            .map { $0 }
            .replaceError(with: GameDetailResponse())
            .assign(to: \.gamePerstoreDetail, on: self)
            .store(in: &stores)
    }
}

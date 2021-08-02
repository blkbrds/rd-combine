//
//  SearchCellViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 8/1/21.
//

import UIKit
import Combine

final class SearchCellViewModel {

    var game: GameDetailResponse

    init(game: GameDetailResponse) {
        self.game = game
    }
}

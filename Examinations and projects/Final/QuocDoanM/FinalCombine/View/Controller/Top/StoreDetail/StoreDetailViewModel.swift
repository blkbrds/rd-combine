//
//  StoreDetailViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import Foundation
import Combine

final class StoreDetailViewModel {

    enum StoreDetailType: String, CaseIterable {
        case storeDetail
        case gamePerStore
    }

    @Published var storeDetail: StoreResult = StoreResult()
    @Published var gamePerstoreDetail: GameDetailResponse = GameDetailResponse()
    var store: StoreResult
    var storeDetailTypes = StoreDetailType.allCases.map { $0 }
    var stores = [AnyCancellable]()

    init(store: StoreResult) {
        self.store = store
    }

    func getSectionType(at indexPath: IndexPath) -> StoreDetailType {
        guard indexPath.section < storeDetailTypes.count else { return .storeDetail }
        return StoreDetailType.allCases[indexPath.section]
    }

    func numberOfSections() -> Int {
        return storeDetailTypes.count
    }

    func numberOfRows(in section: Int) -> Int {
        let section = storeDetailTypes[section]
        switch section {
        case .storeDetail:
            return 1
        default:
            return store.games?.count ?? 0
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any {
        let section = getSectionType(at: indexPath)
        switch section {
        case .storeDetail:
            let viewModel = StoreDetailCellViewModel(imageString: store.imgBackground ?? "", des: storeDetail.description ?? "" )
            return viewModel
        default:
            let gameDetail: Game = store.games?[indexPath.row] ?? Game()
            let viewModel = GamePerStoreCellViewModel(gameDetail: gameDetail)
            return viewModel
        }
    }
}

// MARK: - APIs
extension StoreDetailViewModel {
    func getStoreDetail() {
        API.Store.requestStoreDetail(id: store.id)
            .map { $0 }
            .replaceError(with: StoreResult())
            .assign(to: \.storeDetail, on: self)
            .store(in: &stores)
    }
}

//
//  HomeViewModel.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 3/2/21.
//

import Foundation

final class HomeViewModel {

    // MARK: - Properties
    private(set) var delegateInfo: Info?
    private(set) var closureInfo: Info?
    private(set) var notificationInfo: Info?
    private(set) var combineInfo: Info?
    
    // MARK: - Public func
    func viewModelForInfoView(viewType: InfoViewType) -> InfoViewModel {
        switch viewType {
        case .delegate:
            return InfoViewModel(viewType: viewType, info: delegateInfo)
        case .closure:
            return InfoViewModel(viewType: viewType, info: closureInfo)
        case .notification:
            return InfoViewModel(viewType: viewType, info: notificationInfo)
        case .combine:
            return InfoViewModel(viewType: viewType, info: combineInfo)
        }
    }

    func viewModeForEdit(fromViewType: InfoViewType) -> EditViewModel {
        switch fromViewType {
        case .delegate:
            return EditViewModel(info: delegateInfo, fromViewType: .delegate)
        case .closure:
            return EditViewModel(info: closureInfo, fromViewType: .closure)
        case .notification:
            return EditViewModel(info: notificationInfo, fromViewType: .notification)
        case .combine:
            return EditViewModel(info: combineInfo, fromViewType: .combine)
        }
    }

    func updateInfo(viewType: InfoViewType, info: Info) {
        switch viewType {
        case .delegate:
            delegateInfo = info
        case .closure:
            closureInfo = info
        case .notification:
            notificationInfo = info
        case .combine:
            combineInfo = info
        }
    }
}

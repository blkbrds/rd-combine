//
//  InfoViewModel.swift
//  CombineTest1
//
//  Created by Khoa Vo T.A. on 2/28/21.
//

import Foundation

enum InfoViewType {
    case delegate
    case closure
    case notification
    case combine

    var title: String {
        switch self {
        case .delegate:
            return "Edit\n(Delegate)"
        case .closure:
            return "Edit\n(Closure)"
        case .notification:
            return "Edit\n(Notification)"
        case .combine:
            return "Edit\n(Combine)"
        }
    }
}

final class InfoViewModel {

    // MARK: - Properties
    private(set) var viewType: InfoViewType
    private(set) var info: Info?

    init(viewType: InfoViewType, info: Info?) {
        self.viewType = viewType
        self.info = info
    }
}

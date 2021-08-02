//
//  WorkCellViewModel.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class WorkCellViewModel {

    // MARK: - Properties
    private(set) var title: String
    private(set) var subtitle: String?

    // MARK: - Init
    init(work: Work) {
        title = work.title
        if let issued = work.issued, let parts = issued.parts {
            let dateStr = parts.map { "\($0)" }.joined(separator: "/")
            subtitle = dateStr
        }
        if let publisher = work.publisher {
            if let subtitle = subtitle {
                self.subtitle = subtitle + " ･ " + publisher
            } else {
                subtitle = publisher
            }
        }
    }
}

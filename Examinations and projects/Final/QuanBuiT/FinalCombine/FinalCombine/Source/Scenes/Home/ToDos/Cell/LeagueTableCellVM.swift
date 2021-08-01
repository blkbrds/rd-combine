//
//  LeagueTableCellVM.swift
//  FinalCombine
//
//  Created by Quan Bui T. VN.Danang on 8/1/21.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Foundation
import Domain

final class LeagueTableCellVM {
    // MARK: - Properties
    var dataAPI: ToDo
    
    // MARK: - Init
    init(dataAPI: ToDo) {
        self.dataAPI = dataAPI
    }
}

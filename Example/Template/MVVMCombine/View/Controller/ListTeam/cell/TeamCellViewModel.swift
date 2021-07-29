//
//  TeamCellViewModel.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/16/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class TeamCellViewModel {

    // MARK: - Properties
    private(set) var logo: String = ""
    private(set) var nameClub: String = ""
    private(set) var nameStadium: String = ""
    private(set) var intFormedYear: String = ""

    // MARK: - Initial
    init(logo: String = "", nameClub: String = "", nameStadium: String = "", intFormedYear: String = "") {
        self.logo = logo
        self.nameClub = nameClub
        self.nameStadium = nameStadium
        self.intFormedYear = intFormedYear
    }
}

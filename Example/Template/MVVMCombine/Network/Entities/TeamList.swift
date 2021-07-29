//
//  TeamList.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/17/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class TeamList: Decodable {

    // MARK: - Properties
    var teams: [Team]

    enum CodingKeys: String, CodingKey {
        case teams
    }
}

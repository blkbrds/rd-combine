//
//  Team.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/16/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Team: Decodable, Hashable {

    // MARK: - Properties
    private(set) var strTeam: String
    private(set) var strAlternate: String
    private(set) var intFormedYear: String
    private(set) var strLeague: String
    private(set) var strStadium: String
    private(set) var strKeywords: String
    private(set) var strStadiumThumb: String
    private(set) var strStadiumDescription: String
    private(set) var strWebsite: String
    private(set) var strDescriptionEN: String
    private(set) var strTeamJersey: String
    private(set) var strTeamLogo: String
    private(set) var strTeamBadge: String
    private(set) var strTeamFanart1: String
    private(set) var strTeamFanart2: String
    private(set) var strTeamFanart3: String
    private(set) var strTeamFanart4: String
    private(set) var strTeamBanner: String
    private(set) var strStadiumLocation: String
    private(set) var strFacebook: String
    private(set) var strTwitter: String
    private(set) var strInstagram: String


    enum CodingKeys: String, CodingKey {
        case strTeam
        case strAlternate
        case intFormedYear
        case strLeague
        case strStadium
        case strKeywords
        case strStadiumThumb
        case strStadiumDescription
        case strWebsite
        case strDescriptionEN
        case strTeamJersey
        case strTeamLogo
        case strTeamBadge
        case strTeamFanart1
        case strTeamFanart2
        case strTeamFanart3
        case strTeamFanart4
        case strTeamBanner
        case strStadiumLocation
        case strFacebook
        case strTwitter
        case strInstagram
    }

    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.strTeam == rhs.strTeam
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(strTeam)
    }
}

//
//  DetailTeamViewModel.swift
//  MVVMCombine
//
//  Created by Tam Nguyen K. T. [7] VN.Danang on 7/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

enum SectionType: Int {
    case description
    case stadium
    case player

    var title: String {
        switch self {
        case .description:
            return "Description"
        case .stadium:
            return "Introduce Stadium"
        case .player:
            return "Player"
        }
    }

    var numberCell: Int {
        switch self {
        case .description:
            return 1
        case .stadium:
            return 1
        case .player:
            return 1
        }
    }
}

class Model {
    var strAlternate: String
    var strTeamBadge: String
    var strTeamFanart1: String
    var strTeamFanart2: String
    var strTeamFanart3: String
    var strTeamFanart4: String
    var strStadiumLocation: String
    var strFacebook: String
    var strInstagram: String
    var strTwitter: String
    var strWebsite: String
    var strDescriptionEN: String

    init(strAlternate: String, strTeamBadge: String, strTeamFanart1: String, strTeamFanart2: String, strTeamFanart3: String, strTeamFanart4: String, strStadiumLocation: String, strFacebook: String, strInstagram: String, strTwitter: String, strWebside: String, strDescriptionEN: String) {
        self.strAlternate = strAlternate
        self.strTeamBadge = strTeamBadge
        self.strTeamFanart1 = strTeamFanart1
        self.strTeamFanart2 = strTeamFanart2
        self.strTeamFanart3 = strTeamFanart3
        self.strTeamFanart4 = strTeamFanart4
        self.strStadiumLocation = strStadiumLocation
        self.strFacebook = strFacebook
        self.strInstagram = strInstagram
        self.strTwitter = strTwitter
        self.strWebsite = strWebside
        self.strDescriptionEN = strDescriptionEN
    }
}

final class DetailTeamViewModel {

    // MARK: - Properties
    @Published var strAlternate: String?
    @Published var strTeamBadge: String?
    @Published var strTeamFanart1: String?
    @Published var strTeamFanart2: String?
    @Published var strTeamFanart3: String?
    @Published var strTeamFanart4: String?
    @Published var strStadiumLocation: String?
    @Published var strFacebook: String?
    @Published var strInstagram: String?
    @Published var strTwitter: String?
    @Published var strWebsite: String?
    @Published var strDescriptionEN: String?

    // Model
    var team: Model
    // publisher
//    @Published var teamPub: Team
//    private(set) var team: Team

    // MARK: - Initial

    init(strAlternate: String, strTeamBadge: String, strTeamFanart1: String, strTeamFanart2: String, strTeamFanart3: String, strTeamFanart4: String, strStadiumLocation: String, strFacebook: String, strInstagram: String, strTwitter: String, strWebside: String, strDescriptionEN: String) {
        self.strAlternate = strAlternate
        self.strTeamBadge = strTeamBadge
        self.strTeamFanart1 = strTeamFanart1
        self.strTeamFanart2 = strTeamFanart2
        self.strTeamFanart3 = strTeamFanart3
        self.strTeamFanart4 = strTeamFanart4
        self.strStadiumLocation = strStadiumLocation
        self.strFacebook = strFacebook
        self.strInstagram = strInstagram
        self.strTwitter = strTwitter
        self.strWebsite = strWebside
        self.strDescriptionEN = strDescriptionEN
        
        self.team = .init(strAlternate: strAlternate, strTeamBadge: strTeamBadge, strTeamFanart1: strTeamFanart1, strTeamFanart2: strTeamFanart2, strTeamFanart3: strTeamFanart3, strTeamFanart4: strTeamFanart4, strStadiumLocation: strStadiumLocation, strFacebook: strFacebook, strInstagram: strInstagram, strTwitter: strTwitter, strWebside: strWebside, strDescriptionEN: strDescriptionEN)
    }

    func setTitleSection(section: Int) -> String {
        guard let type = SectionType.init(rawValue: section) else { return "" }
        return type.title
    }

    func numberOfItem(in section: Int) -> Int {
        guard let type = SectionType.init(rawValue: section) else { return 0 }
        return type.numberCell
    }
}

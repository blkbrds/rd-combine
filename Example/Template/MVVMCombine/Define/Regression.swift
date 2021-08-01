//
//  Regression.swift
//  MVVMCombine
//
//  Created by Van Le H. on 5/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

typealias Regressions = App.Regressions

extension App.Regressions {

    // Common
    static let emailAddress = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,254}"
    static let password = "^[a-zA-Z0-9#?!@$%^&;*\"-_￥)(]{4,20}$"
}

extension App.Regressions {
    enum Contains {
        case hiragana
        case katakana
        case kanji
        case alphabet
        case symbol
        case space
        case digit
        case hyphen
        case specialCharacters

        var regrex: String {
            switch self {
            case .hiragana:
                return "ぁ-ん"
            case .katakana:
                return "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンァィゥェォャュョヮッガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴ−‐−—ー"
            case .kanji:
                return "一-龥"
            case .alphabet:
                return "a-zA-Z"
            case .symbol:
                return "!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~"
            case .space:
                return "\\s"
            case .digit:
                return "0-9０-９"
            case .hyphen:
                return "-"
            case .specialCharacters:
                return "#?!@$%^&;*\"-_￥)("
            }
        }
    }
}

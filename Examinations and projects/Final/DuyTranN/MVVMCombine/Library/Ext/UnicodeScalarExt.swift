//
//  UnicodeScalarExt.swift
//  MVVMCombine
//
//  Created by Khoa Vo T.A. VN.Danang on 5/31/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

extension UnicodeScalar {

    // MARK: -
    /// East Asian Halfwidth (H)
    /// All characters that are explicitly defined as Halfwidth in the
    /// Unicode Standard by having a compatibility decomposition of
    /// type <narrow> to characters elsewhere in the Unicode Standard
    /// that are implicitly wide but unmarked, plus U+20A9 ₩ WON SIGN.
    ///
    /// See: http://unicode.org/reports/tr11/#ED3
    ///      https://github.com/audreyt/Unicode-EastAsianWidth/blob/master/lib/Unicode/EastAsianWidth.pm#L209-L215
    var isEastAsianHalfwidth: Bool {
        switch self.value {
        case 0x20A9...0x20A9: return true
        case 0xFF61...0xFFDC: return true
        case 0xFFE8...0xFFEE: return true
        default:
            return false
        }
    }

    /// East Asian Fullwidth (F)
    /// All characters that are defined as Fullwidth in the Unicode Standard
    /// by having a compatibility decomposition of type <wide> to characters
    /// elsewhere in the Unicode Standard that are implicitly narrow but unmarked.
    ///
    /// See: http://unicode.org/reports/tr11/#ED2
    ///      https://github.com/audreyt/Unicode-EastAsianWidth/blob/master/lib/Unicode/EastAsianWidth.pm#L201-L207
    var isEastAsianFullwidth: Bool {
        switch self.value {
        case 0x3000...0x3000: return true
        case 0xFF01...0xFF60: return true
        case 0xFFE0...0xFFE6: return true
        default:
            return false
        }
    }

    /// East Asian Narrow (Na)
    /// All other characters that are always narrow and have explicit fullwidth
    /// or wide counterparts. These characters are implicitly narrow in East Asian
    /// typography and legacy character sets because they have explicit fullwidth or
    /// wide counterparts. All of ASCII is an example of East Asian Narrow characters.
    ///
    /// See: http://unicode.org/reports/tr11/#ED5
    ///      https://github.com/audreyt/Unicode-EastAsianWidth/blob/master/lib/Unicode/EastAsianWidth.pm#L217-L227
    var isEastAsianNarrow: Bool {
        switch self.value {
        case 0x0020...0x007E: return true
        case 0x00A2...0x00A3: return true
        case 0x00A5...0x00A6: return true
        case 0x00AC...0x00AC: return true
        case 0x00AF...0x00AF: return true
        case 0x27E6...0x27EB: return true
        case 0x2985...0x2986: return true
        default:
            return false
        }
    }

    /// Neutral (Not East Asian):
    /// All other characters. Neutral characters do not occur in legacy East Asian
    /// character sets. By extension, they also do not occur in East Asian typography.
    /// For example, there is no traditional Japanese way of typesetting Devanagari.
    /// Canonical equivalents of narrow and neutral characters may not themselves be
    /// narrow or neutral respectively. For example, U+00C5 Å LATIN CAPITAL LETTER A
    /// WITH RING ABOVE is Neutral, but its decomposition starts with a Narrow character.
    ///
    /// See: http://unicode.org/reports/tr11/#ED7
    ///      https://github.com/audreyt/Unicode-EastAsianWidth/blob/master/lib/Unicode/EastAsianWidth.pm#L229-L400
    var isEastAsianNeutral: Bool {
        switch self.value {
        case 0x0000...0x001F: return true
        case 0x007F...0x00A0: return true
        case 0x00A9...0x00A9: return true
        case 0x00AB...0x00AB: return true
        case 0x00B5...0x00B5: return true
        case 0x00BB...0x00BB: return true
        case 0x00C0...0x00C5: return true
        case 0x00C7...0x00CF: return true
        case 0x00D1...0x00D6: return true
        case 0x00D9...0x00DD: return true
        case 0x00E2...0x00E5: return true
        case 0x00E7...0x00E7: return true
        case 0x00EB...0x00EB: return true
        case 0x00EE...0x00EF: return true
        case 0x00F1...0x00F1: return true
        case 0x00F4...0x00F6: return true
        case 0x00FB...0x00FB: return true
        case 0x00FD...0x00FD: return true
        case 0x00FF...0x0100: return true
        case 0x0102...0x0110: return true
        case 0x0112...0x0112: return true
        case 0x0114...0x011A: return true
        case 0x011C...0x0125: return true
        case 0x0128...0x012A: return true
        case 0x012C...0x0130: return true
        case 0x0134...0x0137: return true
        case 0x0139...0x013E: return true
        case 0x0143...0x0143: return true
        case 0x0145...0x0147: return true
        case 0x014C...0x014C: return true
        case 0x014E...0x0151: return true
        case 0x0154...0x0165: return true
        case 0x0168...0x016A: return true
        case 0x016C...0x01CD: return true
        case 0x01CF...0x01CF: return true
        case 0x01D1...0x01D1: return true
        case 0x01D3...0x01D3: return true
        case 0x01D5...0x01D5: return true
        case 0x01D7...0x01D7: return true
        case 0x01D9...0x01D9: return true
        case 0x01DB...0x01DB: return true
        case 0x01DD...0x0250: return true
        case 0x0252...0x0260: return true
        case 0x0262...0x02C3: return true
        case 0x02C5...0x02C6: return true
        case 0x02C8...0x02C8: return true
        case 0x02CC...0x02CC: return true
        case 0x02CE...0x02CF: return true
        case 0x02D1...0x02D7: return true
        case 0x02DC...0x02DC: return true
        case 0x02DE...0x02DE: return true
        case 0x02E0...0x02FF: return true
        case 0x0374...0x0390: return true
        case 0x03AA...0x03B0: return true
        case 0x03C2...0x03C2: return true
        case 0x03CA...0x0400: return true
        case 0x0402...0x040F: return true
        case 0x0450...0x0450: return true
        case 0x0452...0x10FC: return true
        case 0x1160...0x200F: return true
        case 0x2011...0x2012: return true
        case 0x2017...0x2017: return true
        case 0x201A...0x201B: return true
        case 0x201E...0x201F: return true
        case 0x2022         : return true
        case 0x2023...0x2023: return true
        case 0x2028...0x202F: return true
        case 0x2031...0x2031: return true
        case 0x2034...0x2034: return true
        case 0x2036...0x203A: return true
        case 0x203C...0x203D: return true
        case 0x203F...0x2071: return true
        case 0x2075...0x207E: return true
        case 0x2080...0x2080: return true
        case 0x2085...0x20A8: return true
        case 0x20AA...0x20AB: return true
        case 0x20AD...0x2102: return true
        case 0x2104...0x2104: return true
        case 0x2106...0x2108: return true
        case 0x210A...0x2112: return true
        case 0x2114...0x2115: return true
        case 0x2117...0x2120: return true
        case 0x2123...0x2125: return true
        case 0x2127...0x212A: return true
        case 0x212C...0x214E: return true
        case 0x2155...0x215A: return true
        case 0x215F...0x215F: return true
        case 0x216C...0x216F: return true
        case 0x217A...0x2184: return true
        case 0x219A...0x21B7: return true
        case 0x21BA...0x21D1: return true
        case 0x21D3...0x21D3: return true
        case 0x21D5...0x21E6: return true
        case 0x21E8...0x21FF: return true
        case 0x2201...0x2201: return true
        case 0x2204...0x2206: return true
        case 0x2209...0x220A: return true
        case 0x220C...0x220E: return true
        case 0x2210...0x2210: return true
        case 0x2212...0x2214: return true
        case 0x2216...0x2219: return true
        case 0x221B...0x221C: return true
        case 0x2221...0x2222: return true
        case 0x2224...0x2224: return true
        case 0x2226...0x2226: return true
        case 0x222D...0x222D: return true
        case 0x222F...0x2233: return true
        case 0x2238...0x223B: return true
        case 0x223E...0x2247: return true
        case 0x2249...0x224B: return true
        case 0x224D...0x2251: return true
        case 0x2253...0x225F: return true
        case 0x2262...0x2263: return true
        case 0x2268...0x2269: return true
        case 0x226C...0x226D: return true
        case 0x2270...0x2281: return true
        case 0x2284...0x2285: return true
        case 0x2288...0x2294: return true
        case 0x2296...0x2298: return true
        case 0x229A...0x22A4: return true
        case 0x22A6...0x22BE: return true
        case 0x22C0...0x2311: return true
        case 0x2313...0x2328: return true
        case 0x232B...0x244A: return true
        case 0x24EA...0x24EA: return true
        case 0x254C...0x254F: return true
        case 0x2574...0x257F: return true
        case 0x2590...0x2591: return true
        case 0x2596...0x259F: return true
        case 0x25A2...0x25A2: return true
        case 0x25AA...0x25B1: return true
        case 0x25B4...0x25B5: return true
        case 0x25B8...0x25BB: return true
        case 0x25BE...0x25BF: return true
        case 0x25C2...0x25C5: return true
        case 0x25C9...0x25CA: return true
        case 0x25CC...0x25CD: return true
        case 0x25D2...0x25E1: return true
        case 0x25E6...0x25EE: return true
        case 0x25F0...0x2604: return true
        case 0x2607...0x2608: return true
        case 0x260A...0x260D: return true
        case 0x2610...0x2613: return true
        case 0x2616...0x261B: return true
        case 0x261D...0x261D: return true
        case 0x261F...0x263F: return true
        case 0x2641...0x2641: return true
        case 0x2643...0x265F: return true
        case 0x2662...0x2662: return true
        case 0x2666...0x2666: return true
        case 0x266B...0x266B: return true
        case 0x266E...0x266E: return true
        case 0x2670...0x273C: return true
        case 0x273E...0x2775: return true
        case 0x2780...0x27E5: return true
        case 0x27F0...0x2984: return true
        case 0x2987...0x2E1D: return true
        case 0x303F...0x303F: return true
        case 0x4DC0...0x4DFF: return true
        case 0xA700...0xA877: return true
        case 0xD800...0xDB7F: return true // Surrogate pair. `UnicodeScalar` does not support these values.
        case 0xDB80...0xDBFF: return true // Surrogate pair. `UnicodeScalar` does not support these values.
        case 0xDC00...0xDFFF: return true // Surrogate pair. `UnicodeScalar` does not support these values.
        case 0xFB00...0xFDFD: return true
        case 0xFE20...0xFE23: return true
        case 0xFE70...0xFEFF: return true
        case 0xFFF9...0xFFFC: return true
        case 0x10000...0x1D7FF: return true
        case 0xE0001...0xE007F: return true
        default:
            return false
        }
    }

    /// East Asian Wide (W)
    /// All other characters that are always wide. These characters occur only in
    /// the context of East Asian typography where they are wide characters (such
    /// as the Unified Han Ideographs or Squared Katakana Symbols). This category
    /// includes characters that have explicit halfwidth counterparts, along with
    /// characters that have the UTR51 property Emoji_Presentation, with the exception
    /// of the range U+1F1E6 REGIONAL INDICATOR SYMBOL LETTER A through U+1F1FF
    /// REGIONAL INDICATOR SYMBOL LETTER Z.
    ///
    /// See: http://unicode.org/reports/tr11/#ED4
    /// https://github.com/audreyt/Unicode-EastAsianWidth/blob/master/lib/Unicode/EastAsianWidth.pm#L402-L422
    var isEastAsianWide: Bool {
        switch self.value {
        case 0x1100...0x115F: return true
        case 0x2329...0x232A: return true
        case 0x2E80...0x2FFB: return true
        case 0x3001...0x303E: return true
        case 0x3041...0x33FF: return true
        case 0x3400...0x4DB5: return true
        case 0x4E00...0x9FBB: return true
        case 0xA000...0xA4C6: return true
        case 0xAC00...0xD7A3: return true
        case 0xF900...0xFAD9: return true
        case 0xFE10...0xFE19: return true
        case 0xFE30...0xFE6B: return true
        case 0x20000...0x2A6D6: return true
        case 0x2A6D7...0x2F7FF: return true
        case 0x2F800...0x2FA1D: return true
        case 0x2FA1E...0x2FFFD: return true
        case 0x30000...0x3FFFD: return true
        default:
            return false
        }
    }

    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
             0x1F300...0x1F5FF, // Misc Symbols and Pictographs
             0x1F680...0x1F6FF, // Transport and Map
             0x1F1E6...0x1F1FF, // Regional country flags
             0x2600...0x26FF,   // Misc symbols
             0x2700...0x27BF,   // Dingbats
             0xFE00...0xFE0F,   // Variation Selectors
             0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
             127_000...127_600, // Various asian characters
             65_024...65_039, // Variation selector
             9_100...9_300, // Misc items
             8_400...8_447: // Combining Diacritical Marks for Symbols
            return true
        default: return false
        }
    }

    // See more: https://unicode-table.com/en/blocks/halfwidth-and-fullwidth-forms/
    var isKatakanaHalfWidth: Bool {
        switch value {
        case 0xFF65...0xFF9F:
            return true
        default:
            return false
        }
    }

    var isFullwidth: Bool {
        return isEastAsianFullwidth
            || isEastAsianWide
    }

    var isHalfwidth: Bool {
        return isEastAsianHalfwidth
            || isEastAsianNarrow
            || isEastAsianNeutral
    }
}

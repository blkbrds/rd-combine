//
//  Api.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/7/21.
//

import Foundation

struct Api {
    struct URLs {
        static func drink(keySearch: String) -> String {
            return "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(keySearch)"
        }

        static func defaultData() -> String {
            return "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a"
        }
    }
}


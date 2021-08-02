//
//  Cast.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 02/08/2021.
//

import Foundation
import ObjectMapper

final class Cast: Mappable {

    var profileImageString: String = ""
    var name: String?

    init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        profileImageString <- map["profile_path"]
        profileImageString = API.Path.baseImage + profileImageString
    }


}

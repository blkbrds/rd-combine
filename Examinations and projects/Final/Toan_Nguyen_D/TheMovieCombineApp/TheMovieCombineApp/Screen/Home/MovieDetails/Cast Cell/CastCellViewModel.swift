//
//  CastCellViewModel.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 02/08/2021.
//

import Foundation
import Combine

final class CastCellViewModel: ObservableObject {
    var castName: String = ""
    var profileURLString: String?

    init(castName: String, profileString: String? = nil) {
        self.castName = castName
        self.profileURLString = profileString
    }
}

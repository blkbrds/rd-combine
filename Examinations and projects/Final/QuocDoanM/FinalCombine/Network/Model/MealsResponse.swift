//
//  MealsResponse.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/27/21.
//

import UIKit

struct MealResponse: Decodable {

    let browse: [Browse]
    let shopping: [Shopping]

    private enum CodingKeys: String, CodingKey {
        case browse = "browse-categories", shopping = "shopping-categories"
    }
}

struct Meal: Codable, Hashable {
    
    let averageRating: Double
    let totalReviewCount: Int
    let sortBy: String

    private enum CodingKeys: String, CodingKey {
        case averageRating = "averageRating", totalReviewCount = "totalReviewCount", sortBy = "sortBy"
    }
}

struct Browse: Codable, Hashable {

    let promoted: Bool
    let trackingID: String
    let browseType: String
    let display: Display
    let content: String

    private enum CodingKeys: String, CodingKey {
        case promoted = "promoted", trackingID = "tracking-id", browseType = "type", display = "display", content = "content"
    }
}

struct Shopping: Codable, Hashable {
    
    let promoted: Bool
    let trackingID: String
    let browseType: String
    let display: Display
    let content: String

    private enum CodingKeys: String, CodingKey {
        case promoted = "promoted", trackingID = "tracking-id", browseType = "type", display = "display", content = "content"
    }
}

struct Display: Codable, Hashable {
    let displayName: String
    let categoryImage: String
    let tag: String

    private enum CodingKeys: String, CodingKey {
        case displayName = "displayName", categoryImage = "categoryImage", tag = "tag"
    }
}

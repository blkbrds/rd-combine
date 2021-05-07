//
//  APIResponse.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/20/21.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    
    let drinks: [T]
    
    private enum CodingKeys: String, CodingKey {
        case drinks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        drinks = (try? container.decode([T].self, forKey: .drinks)).unwrapped(or: [])
    }
}

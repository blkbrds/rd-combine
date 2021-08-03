//
//  Encodable.swift
//  Foody
//
//  Created by An Nguyễn on 29/04/2021.
//

import Foundation

extension Encodable {
  func toParameters() throws -> Parameters {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters else {
      throw NSError()
    }
    return dictionary
  }
}

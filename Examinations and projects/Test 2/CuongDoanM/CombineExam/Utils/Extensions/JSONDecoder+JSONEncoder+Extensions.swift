//
//  JSONDecoder+JSONEncoder+Extensions.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/23/21.
//

import UIKit

extension JSONDecoder {
    
    static func customUTC(withFormat type: DateFormatter.DateFormatType) -> JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        let dateFormatter: DateFormatter = DateFormatter.withUTCTimeZone(withFormat: type)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

extension JSONEncoder {
    
    static func customUTC(withFormat type: DateFormatter.DateFormatType) -> JSONEncoder {
        let encoder: JSONEncoder = JSONEncoder()
        let dateFormatter: DateFormatter = DateFormatter.withUTCTimeZone(withFormat: type)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}

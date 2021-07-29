//
//  ResponseData.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

// API DOCS: https://github.com/CrossRef/rest-api-doc
/*
Example JSON to be used:
 {
     "status": "ok",
     "message-type": "type-list",
     "message-version": "1.0.0",
     "message": {
         "total-results": 1,
         "items": [
             {
                 "id": "book-section",
                 "label": "Book Section"
             }
         ]
     }
 }
 OR
 {
     "status": "ok",
     "message-type": "type",
     "message-version": "1.0.0",
     "message": {
         "id": "book-section",
         "label": "Book Section"
     }
 }
 OR
 {
     "status": "error",
     "message-type": "exception",
     "message-version": "1.0.0",
     "message": {
         "name": "class java.lang.ClassCastException",
         "description": "java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.CharSequence",
         "message": "java.lang.Long cannot be cast to java.lang.CharSequence",
         "stack": [
             "clojure.core$re_matcher.invokeStatic(core.clj:4667)",
             "clojure.core$re_matches.invokeStatic(core.clj:4704)"
         ],
         "cause": null
     }
 }
 */

struct ResponseData<T: Decodable>: Decodable {
    var team: T

    enum CodingKeys: String, CodingKey {
        case teams
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        team = try container.decode(T.self, forKey: .teams)
    }
}

/*
Use in case data is null or empty, such as:
 {
     "status": "ok",
     "message-type": "type",
     "message-version": "1.0.0",
     "message": null
 }
 **/
struct EmptyData: Codable { }

/*
Example JSON to be used:
 {
     "name": "class java.lang.ClassCastException",
     "description": "java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.CharSequence",
     "message": "java.lang.Long cannot be cast to java.lang.CharSequence",
     "stack": [
         "clojure.core$re_matcher.invokeStatic(core.clj:4667)",
         "clojure.core$re_matches.invokeStatic(core.clj:4704)"
     ],
     "cause": null
 }
 */
struct ErrorData: Codable {
    var name: String
    var description: String
    var message: String
    var stack: [String]
    var cause: String?
}
